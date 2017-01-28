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

class SavedMemesTableVC: UITableViewController {
    
    var memes : [Meme] {
        return appDel.memes
    }
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSavedMemes))
        editButton.possibleTitles = Set(["Done", "Edit"])
        tabBarController?.navigationItem.leftBarButtonItem = editButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        editButton.isEnabled = !memes.isEmpty
    }
    
    func editSavedMemes() {
        configureEditButton(editing: true)
    }
    
    func cancelEditing() {
        configureEditButton(editing: false)
    }
    
    func configureEditButton(editing: Bool) {
        if editing {
            editButton.action = #selector(cancelEditing)
            editButton.title = "Done"
            tableView.setEditing(true, animated: true)
        } else {
            editButton.title = "Edit"
            editButton.action = #selector(editSavedMemes)
            tableView.setEditing(false, animated: true)
        }
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
        if let data = meme.image {
            cell.memeImageView.image = UIImage(data: data as Data)
        }
        cell.timeStamp.text = appDel.configureTimestamp(date: meme.timeStamp as! Date, desiredFormat: "MMM dd, yyyy")
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete") {(action, indexPath) in
            self.appDel.deleteMeme(meme: self.memes[indexPath.row])
            self.appDel.memes.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            if self.memes.isEmpty {
                self.configureEditButton(editing: false)
            }
        }]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

