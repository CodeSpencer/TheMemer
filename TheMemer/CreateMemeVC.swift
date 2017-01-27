//
//  CreateMemeVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    var meme: Meme?
    
    var placeholderString = "Type To Tap"
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //text view delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderString {
            textView.text.removeAll()
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.endEditing(true)
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextView.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo! [UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
            return false
        }
        return true
    }
    
    func configureUI() {
        actionButton.isEnabled = (meme != nil) ? true : false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) ? true : false
        
        if let data = meme?.image {
            memeImageView.image = UIImage(data: data as Data)!
        } else {
            memeImageView.image = UIImage(named: "placeHolder")!
        }
        topTextView.text = meme?.topText ?? placeholderString
        bottomTextView.text = meme?.bottomText ?? placeholderString
        topTextView.delegate = self
        bottomTextView.delegate = self
        let memeTextAttributes = [NSStrokeColorAttributeName: UIColor(white: 0.0, alpha: 1.0), NSForegroundColorAttributeName: UIColor(white: 2.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: NSNumber(value: -3.0 as Float)]
        topTextView.typingAttributes = memeTextAttributes
        bottomTextView.typingAttributes = memeTextAttributes
    }
    
    @IBAction func presentCamera() {
        selectImage(.camera)
    }
    
    @IBAction func presentLibrary() {
        selectImage(.photoLibrary)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentShareController() {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, completed, items, error) in
            if completed {
                self.save(memedImage: memedImage)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        navigationController?.navigationBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(containerView.frame.size)
//        view.clearsContextBeforeDrawing = true
        containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage(named: "placeHolder")!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
 
    func save(memedImage: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Meme", in: managedContext)!
        
        let newMeme = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let image = UIImageJPEGRepresentation(memeImageView.image!, 0) {
            newMeme.setValue(image as NSData, forKey: "image")
        }
        if let memedImage = UIImageJPEGRepresentation(memedImage, 0) {
            newMeme.setValue(memedImage as NSData, forKey: "memedImage")
        }
        newMeme.setValue(topTextView.text, forKeyPath: "topText")
        newMeme.setValue(bottomTextView.text, forKey: "bottomText")
        newMeme.setValue(NSDate(), forKey: "timeStamp")

        do {
            try managedContext.save()
            appDelegate.memes.append(newMeme as! Meme)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)

    }
    
    func selectImage(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.actionButton.isEnabled = true
            self.memeImageView.image = image
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return memeImageView
    }
}






