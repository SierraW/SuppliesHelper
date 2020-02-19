//
//  DetailFinderTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class DetailFinderTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchResult: [ShuyiSupplyItem]?
    var controller: RecordController!
    
    var daoItem = DaoItem()
    
    let searchController = UISearchController.init(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "查找"
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self

        searchController.searchBar.placeholder = "Search Item..."
        //self.tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return searchResult!.count
        } else {
            return controller.itemSet.items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Finder Cell", for: indexPath)
        let label = cell.contentView.subviews[0] as! UILabel
        let lblRight = cell.contentView.subviews[1] as! UILabel

        let itemSet = controller.itemSet.items
        
        if searchController.isActive {
            label.text = searchResult?[indexPath.item].name ?? ""
            let visItem = itemSet[Int(searchResult![indexPath.item].id_item)]
            if controller.itemSet.visited.contains(Int(visItem.shuyiItem.id_item)) {
                lblRight.text = "已确认"
                lblRight.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                lblRight.text = "未确认"
                lblRight.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        } else {
            label.text = controller.itemSet.items[indexPath.item].shuyiItem.name
            if controller.itemSet.visited.contains(indexPath.item) {
                lblRight.text = "已确认"
                lblRight.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                lblRight.text = "未确认"
                lblRight.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem: Int16
        if searchController.isActive {
            currentItem = searchResult![indexPath.item].id_item
        } else {
            currentItem = controller.itemSet.items[indexPath.item].shuyiItem.id_item
        }
        performSegue(withIdentifier: "Modify Item", sender: Int(currentItem))
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
    
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        searchResult = daoItem.getItems(predicate: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Modify Item" {
            if let dmvc = segue.destination as? DetailModifyViewController {
                dmvc.controller = controller
                let index = sender as! Int
                dmvc.itemIndex = index
            }
        }
    }

}
