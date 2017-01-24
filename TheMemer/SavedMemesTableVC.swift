//
//  SavedMemesTableVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class Meme: NSManagedObject {
    @NSManaged var image: UIImage
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var timeStamp: Date
    @NSManaged var memedImage: UIImage
    
    convenience init(image: UIImage, topText: String, bottomText: String, timeStamp: Date, memedImage: UIImage, entity: NSEntityDescription, context: NSManagedObjectContext) {
        self.init(entity: entity, insertInto: context)
        self.image = image
        self.topText = topText
        self.bottomText = bottomText
        self.timeStamp = timeStamp
        self.memedImage = memedImage
    }
    
    func save() {
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Meme", into: managedObjectContext!) as! Meme
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error saving Meme entity")
        }
    }
}

class SavedMemesTableVC: UITableViewController {
    
    var memes : [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
        cell.timeStamp.text = meme.timeStamp.description
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

