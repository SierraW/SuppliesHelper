//
//  LocationSelectionTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class LocationSelectionTableViewController: UITableViewController {

    var daoArea: DaoArea!
    var shuyiAreas: [ShuyiArea] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location Mapping"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")

        daoArea = DaoArea()
        
        shuyiAreas = daoArea.getAreas()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @objc func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        shuyiAreas = daoArea.getAreas()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return shuyiAreas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location Cell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        
        label.text = shuyiAreas[indexPath.item].name!
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Edit Item Location", sender: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit Item Location" {
            if let letvc = segue.destination as? LocationEditionTableViewController, let senderIndexPath = sender as? IndexPath {
                let index = senderIndexPath.item
                letvc.areaIndex = Int16(index)
                letvc.navigationItem.title = shuyiAreas[index].name
            }
        }
    }

}
