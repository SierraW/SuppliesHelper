//
//  DetailOutputTableViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-03.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class DetailOutputTableViewController: UITableViewController {
    
    var controller: RecordController!
    var labledItem: [VisitedItem]!
    var unlabledItem: [VisitedItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return labledItem.count
        } else {
            return unlabledItem.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "已叫货清单"
        } else {
            return "未叫货清单"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Output View Cell", for: indexPath)
        let leftLabel = cell.contentView.subviews[0] as! UILabel
        
        var vi: VisitedItem
        
        if (indexPath.section == 0) {
            vi = labledItem[indexPath.item]
        } else {
            vi = unlabledItem[indexPath.item]
        }
        
        let stack = cell.contentView.subviews[1] as! UIStackView
        
        leftLabel.text = vi.shuyiItem.name
    
        let lblCount = stack.arrangedSubviews[0] as! UILabel
        let stepper = stack.arrangedSubviews[1] as! UIStepper
        
        stepper.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
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
        reloadData()
        tableView.reloadData()
    }

    @IBAction func outputData(_ sender: Any) {
        UIPasteboard.general.string = controller.getOutputStr()
        
        let alert = UIAlertController(title: "提示", message: "复制成功！", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
                }
        let originStr = "已复制到剪切板"
        let attrStr = NSMutableAttributedString(string: originStr)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, originStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, originStr.count))
        alert.setValue(attrStr, forKey: "attributedMessage")

        alert.addAction(sureAction)
        present(alert, animated: true, completion: nil)
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
    
    func reloadData() {
        labledItem = []
        unlabledItem = []
        
        let labeledIndexes = controller.itemSet.labeled.sorted()
        
        var pointer = 0
        let itemSet = controller.itemSet.items
        for i in 0..<itemSet.count {
            if pointer < labeledIndexes.count, labeledIndexes[pointer] == Int(itemSet[i].shuyiItem.id_item) {
                labledItem.append(itemSet[i])
                pointer += 1
            } else {
                unlabledItem.append(itemSet[i])
            }
        }
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
