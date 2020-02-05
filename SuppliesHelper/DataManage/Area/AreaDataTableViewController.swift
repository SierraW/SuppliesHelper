//
//  AreaDataTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-28.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class AreaDataTableViewController: UITableViewController {
    
    var daoArea: DaoArea!
    var shuyiAreas: [ShuyiArea] = []
    
    @IBAction func addNewCell(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Add Location", sender: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        daoArea = DaoArea()
        
        shuyiAreas = daoArea.getAreas()
        
        navigationItem.title = "Location"
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaTableCell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        
        label.text = shuyiAreas[indexPath.item].name!
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shuyiAreas.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        shuyiAreas.insert(shuyiAreas.remove(at: fromIndexPath.item), at: to.item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Edit Location", sender: shuyiAreas[indexPath.item])
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit Location" {
            if let aevc = segue.destination as? AreaEditViewController {
                if let area = sender as? ShuyiArea {
                    aevc.area = area
                    aevc.dao = daoArea
                }
            }
        } else {
            if let aevc = segue.destination as? AreaEditViewController {
                aevc.dao = daoArea
            }
        }
    }


}
