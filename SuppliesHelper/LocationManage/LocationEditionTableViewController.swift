//
//  LocationEditionTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class LocationEditionTableViewController: UITableViewController {
    
    var areaIndex: Int16!
    
    var daoLocation: DaoLocation!
    var selectionSet: LocationSelectionSet!

    override func viewDidLoad() {
        super.viewDidLoad()

        daoLocation = DaoLocation()
        
        selectionSet = daoLocation.getSetLocation(area: areaIndex)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return selectionSet.setLocationItems.count
        } else {
            return selectionSet.unsetLocationItems.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        let rightLabel = cell.contentView.subviews[1] as! UILabel
        
        if (indexPath.section == 0) {
            let item = selectionSet.setLocationItems[indexPath.item]
            label.text = item.shuyiItem.name
            rightLabel.text = ""
        } else {
            let item = selectionSet.unsetLocationItems[indexPath.item]
            if (item.atPlaces == 0) {
                label.text = "\(item.shuyiItem.id_item) \(item.shuyiItem.name!)"
                rightLabel.text = "UNSET"
                rightLabel.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            } else {
                label.text = "\(item.shuyiItem.id_item) \(item.shuyiItem.name!)"
                rightLabel.text = "In \(item.atPlaces!) area(s)"
                rightLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        }

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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "已选择物品"
        } else {
            return "未选择物品"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            selectionSet.deselectItem(at: indexPath.item, dao: daoLocation)
        } else {
            selectionSet.seletcItem(at: indexPath.item, dao: daoLocation)
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
