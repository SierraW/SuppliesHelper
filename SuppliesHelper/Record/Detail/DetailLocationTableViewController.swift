//
//  DetailLocationTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class DetailLocationTableViewController: UITableViewController {
    
    var controller: RecordController!
    var sectionIndex: Int?
    
    var visitedSet: [Int]!
    var unvisitSet: [Int]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 82

        if sectionIndex == nil {
            (visitedSet, unvisitSet) = controller.getItems(at: nil)
        } else {
            (visitedSet, unvisitSet) = controller.getItems(at: sectionIndex)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func scrollToVisited(at position: Int) {
        let index = unvisitSet.count - position - 1
        if index > 0 {
            tableView.scrollToRow(at: IndexPath(item: index, section: 0), at: .middle, animated: false)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return unvisitSet.count
        } else {
            return visitedSet.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "未确认清单"
        } else {
            return "已确认清单"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell", for: indexPath)
        let label = cell.contentView.subviews[1] as! UILabel
        let stack = cell.contentView.subviews[0] as! UIStackView
        
        var vi: VisitedItem
        
        if (indexPath.section == 0) {
            vi = controller.getItem(at: unvisitSet[indexPath.item])
        } else {
            vi = controller.getItem(at: visitedSet[indexPath.item])
        }
        
        label.text = vi.shuyiItem.name
    
        let lblCount = stack.arrangedSubviews[0] as! UILabel
        let stepper = stack.arrangedSubviews[1] as! UIStepper
        
        stepper.transform = CGAffineTransform(scaleX: 1.3, y: 1.4)
        stepper.tag = Int(vi.shuyiItem.id_item)
        stepper.autorepeat = true
        stepper.addTarget(self, action: #selector(tapped), for: .valueChanged)
        
        stepper.value = Double(vi.itemCount ?? -1)
        
        let str = String(vi.itemCount ?? -1)
        if str == "0" {
            lblCount.text = "叫货"
        } else if str == "-1" {
            lblCount.text = ""
        } else {
            lblCount.text = "剩\(str)\(vi.shuyiItem.unit!)"
        }

        return cell
    }
    
    @objc func tapped(sender: UIStepper) {
        let value = Int(sender.value)
        controller.labelItem(at: sender.tag, value: value)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = unvisitSet[indexPath.item]
            controller.visit(at: item)
            visitedSet.insert(item, at: 0)
            reload()
        } else {
            controller.labelItem(at: visitedSet[indexPath.item])
        }
        
        tableView.reloadData()
        scrollToVisited(at: 2)
    }
    
    func reload() {
        if sectionIndex == nil {
            (_, unvisitSet) = controller.getItems(at: nil)
        } else {
            (_, unvisitSet) = controller.getItems(at: sectionIndex)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
