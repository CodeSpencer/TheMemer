//
//  DetailVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import Foundation
import UIKit

class DetailVC: UIViewController {
    
    var meme: Meme?

    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = meme?.memedImage {
            memeImageView.image = UIImage(data: data as Data)
        }
    }
}
