//
//  DetailModifyViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-03.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class DetailModifyViewController: UIViewController, UITextFieldDelegate {
    
    var itemIndex: Int!
    var controller: RecordController!
    var sections: [ShuyiArea]!

    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var segLab: UISegmentedControl!
    
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = []
        let itemMapping = controller.sectionIsolatedItem
        for i in 0..<itemMapping.count {
            if itemMapping[i].contains(itemIndex) {
                sections.append(controller.sections[i])
            }
        }
        
        let visitedItem = controller.itemSet.items[itemIndex]
        
        let index = Int(visitedItem.shuyiItem.id_item)
        if let stackView = view.subviews[0] as? UIStackView {
            if let label = stackView.subviews[0] as? UILabel {
                label.text = visitedItem.shuyiItem.name
            }
            if let segmentVis = stackView.subviews[1] as? UISegmentedControl {
                segmentVis.setTitle("未确认", forSegmentAt: 0)
                segmentVis.setTitle("已确认", forSegmentAt: 1)
                
                let visitedSet =  controller.itemSet.visited
                if visitedSet.contains(index) {
                    segmentVis.selectedSegmentIndex = 1
                }
                
                segmentVis.tag = index
                segmentVis.addTarget(self, action: #selector(visitItem), for: .valueChanged)
            }
            segLab.setTitle("未叫货", forSegmentAt: 0)
            segLab.setTitle("已叫货", forSegmentAt: 1)
            
            
            let labeledSet = controller.itemSet.labeled
            if labeledSet.contains(index) {
                segLab.selectedSegmentIndex = 1
            }
            segLab.tag = index
            segLab.addTarget(self, action: #selector(labelItem), for: .valueChanged)
            
            if let stack = stackView.subviews[3] as? UIStackView {
                if let lblLab = stack.arrangedSubviews[0] as? UILabel {
                    lblLab.text = "剩余数目"
                }
                
                txtField.text = "\(visitedItem.itemCount ?? 0)"
                txtField.tag = index
                txtField.addTarget(self, action: #selector(setLabel), for: .valueChanged)
                    
                stepper.value = Double(visitedItem.itemCount ?? -1)
                stepper.tag = index
                stepper.addTarget(self, action: #selector(stepLabel), for: .valueChanged)
            }
            
        }
    }
    
    @IBAction func touchEvent(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func reloadField() {
        let visitedItem = controller.itemSet.items[itemIndex]
        
        txtField.text = "\(visitedItem.itemCount ?? 0)"
        stepper.value = Double(visitedItem.itemCount ?? -1)
        let labeledSet = controller.itemSet.labeled
        if labeledSet.contains(Int(visitedItem.shuyiItem.id_item)) {
            segLab.selectedSegmentIndex = 1
        } else {
            segLab.selectedSegmentIndex = 0
        }
    }
    
    
    @objc func visitItem(sender: UISegmentedControl) {
        controller.unvisit(at: sender.tag)
    }
    
    @objc func labelItem(sender: UISegmentedControl) {
        controller.labelItem(at: sender.tag)
        reloadField()
    }
    
    @objc func setLabel(sender: UITextField) {
        controller.labelItem(at: sender.tag, value: Int(sender.text ?? "-1"))
        reloadField()
    }
    
    @objc func stepLabel(sender: UIStepper) {
        print(sender.value)
        controller.labelItem(at: sender.tag, value: Int(sender.value))
        reloadField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        return true
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

extension DetailModifyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detail Cell", for: indexPath)
        
        let label = cell.contentView.subviews[0] as! UILabel
        
        label.text = sections[indexPath.item].name
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.contentView.layer.cornerRadius = 3.0
        
        return cell
    }
    
    
}
