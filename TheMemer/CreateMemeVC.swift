//
//  CreateMemeVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import Foundation
import UIKit

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meme: Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        actionButton.isEnabled = (meme != nil) ? true : false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) ? true : false
        
        memeImageView.image = meme?.image ?? UIImage(named: "placeHolder")!
        topTextField.text = meme?.topText ?? "Tap to type"
        bottomTextField.text = meme?.bottomText ?? "Tap to type"
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
    
    @IBAction func presentActions() {
        
    }
    
    func generateMemedImage() {
    
    }
    
    func selectImage(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
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
}





////
////
////  MemeEditorViewController.swift
////  MemeMe first try
////
////  Created by Spencer Halverson on 2/15/16.
////  Copyright © 2016 Spencer Halverson. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        subscribeToKeyboardNotifications()
//        topText.textAlignment = NSTextAlignment.center
//        bottomText.textAlignment = NSTextAlignment.center
//        let memeTextAttributes = [NSStrokeColorAttributeName: UIColor(white: 0.0, alpha: 1.0), NSForegroundColorAttributeName: UIColor(white: 2.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: NSNumber(value: -3.0 as Float)]
//        
//        topText.defaultTextAttributes = memeTextAttributes
//        bottomText.defaultTextAttributes = memeTextAttributes
//        navigationController?.isNavigationBarHidden = true
//        tabBarController?.tabBar.isHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unsubscribeFromKeyboardNotifications()
//    }
//    
//    //text field delegate methods
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text?.removeAll()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//        return true
//    }
//    
//    func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func unsubscribeFromKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func keyboardWillShow(_ notification: Notification) {
//        if bottomText.isFirstResponder {
//            view.frame.origin.y -= getKeyboardHeight(notification)
//        }
//    }
//    
//    func keyboardWillHide(_ notification: Notification){
//        view.frame.origin.y = 0
//    }
//    
//    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo! [UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//    
//    
//    func saveMeme() {
//        
//        let memedImage = generateMemedImage()
//        let meme = AppDelegate.Meme(topField: topText.text!, bottomField: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
//        
//        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
//        
//        navigationController!.popToRootViewController(animated: true)
//    }
//    
//    func generateMemedImage() -> UIImage {
//        toolbar.isHidden = true
//        navBar.isHidden = true
//        
//        // render view to an image
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
//        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        toolbar.isHidden = false
//        navBar.isHidden = false
//        
//        return memedImage
//    }
//    
//    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
//        let meme = generateMemedImage()
//        let shareController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
//        shareController.completionWithItemsHandler = {
//            activity, completed, items, error in
//            if (completed) {
//                self.saveMeme()
//            }
//        }
//        present(shareController, animated: true, completion: nil)
//    }
//    
//    func selectImage(_ sourceType: UIImagePickerControllerSourceType){
//        let pickerController = UIImagePickerController()
//        pickerController.sourceType = sourceType
//        pickerController.delegate = self
//        present(pickerController, animated: true, completion: nil)
//        shareButton.isEnabled = true
//    }
//    
//    
//    
//}

