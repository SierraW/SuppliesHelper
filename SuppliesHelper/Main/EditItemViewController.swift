//
//  EditItemViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-28.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, UITextFieldDelegate {
    
    var item: ShuyiSupplyItem?
    var dao: DaoItem!
    var mode: Mode!
    
    enum Mode {
        case edit
        case add
    }
    
    @IBOutlet weak var idItem: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var areaPicker: EditItemPickerView!
    
    @IBAction func btnSubmit(_ sender: Any) {
        item?.id_area = Int16(areaPicker.selectedRow(inComponent: 0))
        item?.name = txtName.text
        item?.unit = txtUnit.text
        
        dao.save()
        let alert = UIAlertController(title: "提示", message: "提交成功！", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
                }
        let originStr = "提交成功"
        let attrStr = NSMutableAttributedString(string: originStr)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, originStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, originStr.count))
        alert.setValue(attrStr, forKey: "attributedMessage")

        alert.addAction(sureAction)
        present(alert, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dao = DaoItem()
        
        let daoArea = DaoArea()
        areaPicker.areas = daoArea.getAreas()
        
        areaPicker.delegate = areaPicker
        areaPicker.dataSource = areaPicker
    
        if item != nil {
            idItem.text = "\(item!.id_item)"
            txtName.text = item?.name
            txtUnit.text = item?.unit
            areaPicker.selectRow(Int(item!.id_area), inComponent: 0, animated: true)
        }
    
        

        // Do any additional setup after loading the view.
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
