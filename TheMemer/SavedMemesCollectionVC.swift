//
//  SavedMemesCollectionVC.swift
//  TheMemer
//
//  Created by Spencer Halverson on 1/23/17.
//  Copyright © 2017 Spencer Halverson. All rights reserved.
//

import Foundation
import UIKit

class SavedMemesCollectionVC: UICollectionViewController {
    
    var memes : [Meme] {
        return appDel.memes
    }
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var editButton = UIBarButtonItem()
    var editingMemes = false {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayout()
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSavedMemes))
        tabBarController?.navigationItem.leftBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    func editSavedMemes() {
        configureEditButton(editing: true)
    }
    
    func cancelEditing() {
        configureEditButton(editing: false)
    }
    
    func configureEditButton(editing: Bool) {
        self.editingMemes = editing
        if editing {
            editButton.action = #selector(cancelEditing)
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
            editButton.action = #selector(editSavedMemes)
        }
    }
    
    func setFlowLayout() {
        let space : CGFloat = 5.0
        let dimension = (self.view.frame.size.width - (4.0 * space)) / 3.0
        flowLayout.sectionInset.left = space
        flowLayout.sectionInset.right = space
        flowLayout.sectionInset.top = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension + 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        if let data = meme.memedImage {
            cell.memeImageView.image = UIImage(data: data as Data)
        }
        cell.label.text = appDel.configureTimestamp(date: meme.timeStamp as! Date, desiredFormat: "MMM dd, yyyy")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MemeCollectionViewCell {
            cell.deleteButton.isHidden = !self.editingMemes
            cell.deleteButton.isEnabled = self.editingMemes
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        let meme = memes[indexPath.item]
        if editingMemes {
            appDel.deleteMeme(meme: meme)
            appDel.memes.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            if memes.isEmpty {
                configureEditButton(editing: false)
            }
        } else {
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            detailVC.meme = meme
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
