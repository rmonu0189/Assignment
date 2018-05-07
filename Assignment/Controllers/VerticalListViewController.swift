//
//  VerticalListViewController.swift
//  Assignment
//
//  Created by Monu on 05/05/18.
//  Copyright © 2018 Monu. All rights reserved.
//

import UIKit

class VerticalListViewController: UITableViewController {

    // MARK: - Properties
    
    var pictures: [LocalPicture] = [LocalPicture]()
    
    // MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPictures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureTableViewCell.identifier, for: indexPath) as! PictureTableViewCell
        let picture = self.pictures[indexPath.item]
        cell.configurePicture(picture)
        cell.userImageView?.imageFromURL(picture.image, placeholder: #imageLiteral(resourceName: "icPlaceholder"), handler: { (image) in
            if let currentCell = tableView.cellForRow(at: indexPath) as? PictureTableViewCell {
                currentCell.userImageView.image = image
            }
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        NetworkDataManager.cancelRequestFromUrl(self.pictures[indexPath.item].image)
    }
    
    // MARK: - API Services
    
    private func fetchPictures() {
        AppLoader.show()
        LocalPicture.fetchAllWithHandler { (records, error) in
            AppLoader.hide()
            if let pictures = records {
                self.pictures = pictures
                self.tableView.reloadData()
            } else {
                AppAlert.showError(error)
            }
        }
    }

}
