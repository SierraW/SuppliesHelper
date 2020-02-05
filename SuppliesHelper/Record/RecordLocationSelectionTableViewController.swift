//
//  RecordLocationSelectionTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class RecordLocationSelectionTableViewController: UITableViewController {
    
    var controller: RecordController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if controller.record != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            navigationItem.title = dateFormatter.string(from: controller.record.date!)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        controller.saveData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "查找"
        } else if section == 1 {
            return "全局"
        } else {
            return "分区"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else {
            return controller.sections.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Record Location Cell", for: indexPath)

        let leftLabel = cell.contentView.subviews[0] as! UILabel
        let rightLabel = cell.contentView.subviews[1] as! UILabel
        
        if indexPath.section == 0 {
            leftLabel.text = "Find..."
            rightLabel.text = ""
        } else if indexPath.section == 1 {
            if (indexPath.item == 0) {
                leftLabel.text = "已叫货清单->提交"
                rightLabel.text = "\(controller.itemSet.labeled.count)"
                rightLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                leftLabel.text = "未确认清单"
                let count = controller.itemSet.unvisited.count
                rightLabel.text = "\(count)"
                if count > controller.itemSet.items.count / 2 {
                    rightLabel.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                } else if count > 5 {
                    rightLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                } else {
                    rightLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
                
            }
        } else {
            leftLabel.text = controller.sections[indexPath.item].name
            let (_ , unvisited) = controller.getItems(at: indexPath.item)
            let count = unvisited.count
            rightLabel.text = "\(count)"
            if count > 2 {
                rightLabel.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            } else if count != 0 {
                rightLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            } else {
                rightLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "Finder View", sender: nil)
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                performSegue(withIdentifier: "Item Labeled", sender: nil)
            } else {
                performSegue(withIdentifier: "Item Not Visited", sender: indexPath.item)
            }
        } else {
            performSegue(withIdentifier: "From Location", sender: indexPath)
        }
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
        if segue.identifier == "From Location" {
            if let dltvc = segue.destination as? DetailLocationTableViewController, let index = sender as? IndexPath{
                dltvc.sectionIndex = index.item
                dltvc.controller = controller
                dltvc.navigationItem.title = "物品清单"
            }
        } else if segue.identifier == "Item Not Visited" {
            if let dltvc = segue.destination as? DetailLocationTableViewController{
                dltvc.sectionIndex = nil
                dltvc.controller = controller
                dltvc.navigationItem.title = "物品清单"
            }
        } else if segue.identifier == "Finder View" {
            if let dftvc = segue.destination as? DetailFinderTableViewController {
                dftvc.controller = controller
            }
        } else if segue.identifier == "Item Labeled" {
            if let dotvc = segue.destination as? DetailOutputTableViewController {
                dotvc.controller = controller
                dotvc.navigationItem.title = "确认叫货"
            }
        }
    }

}
