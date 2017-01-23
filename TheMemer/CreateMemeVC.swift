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
