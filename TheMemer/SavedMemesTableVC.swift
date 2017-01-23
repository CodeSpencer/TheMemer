//
//  SavedMemesTableVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import UIKit

struct Meme {
    var image: UIImage
    var topText: String
    var bottomText: String
    var timeStamp: String
    var memedImage: UIImage
}

class SavedMemesTableVC: UITableViewController {
    
    var memes : [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        cell.memeImageView.image = meme.image
        cell.timeStamp.text = meme.timeStamp
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

