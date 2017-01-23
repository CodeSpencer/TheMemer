//
//  MemeTableViewCell.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7.0
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1.5
    }
}

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: RoundedImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
}

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: RoundedImageView!
}
