//
//  ItemDataTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-28.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class ItemDataTableViewController: UITableViewController {
    
    var daoItem: DaoItem!
    var arrItems: [ShuyiSupplyItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Items"
        daoItem = DaoItem()
        
        arrItems = daoItem.getItem()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "Edit Item", sender: sender)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataItemCell", for: indexPath)

        let label = cell.contentView.subviews[0] as! UILabel
        
        let item = arrItems[indexPath.item]
        
        label.text = "\(item.id_item). " + item.name!

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Edit Item", sender: indexPath)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Edit Item" {
            let eivc = segue.destination as? EditItemViewController
            if let index = sender as? IndexPath {
                eivc?.mode = EditItemViewController.Mode.edit
                eivc?.item = arrItems?[index.item]
            } else {
                let newItem = daoItem.getItemObject()
                newItem.name = "New Item"
                newItem.id_area = 1
                eivc?.item = newItem
                eivc?.mode = EditItemViewController.Mode.add
            }
        }
    }

}
