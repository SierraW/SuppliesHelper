//
//  ViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-27.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Database"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearRecord(_ sender: Any) {
        let dao = DaoRecord()
        dao.remove(at: nil)
        popUpWindow(notification: "Record")
    }
    
    @IBAction func clearCounterHistory(_ sender: Any) {
        let dao = DaoCupCount()
        dao.remove(at: nil)
        popUpWindow(notification: "数杯器")
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AreaData" {
//            if let adtvc = segue.destination as? AreaDataTableViewController {
//                adtvc.dataType = AreaDataTableViewController.DataType.Area
//            }
//        }
//    }
    
    func popUpWindow(notification str: String) {
        let alert = UIAlertController(title: "提示", message: "重置成功！", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
                }
        
        let originStr = "已置制\(str)数据"
        let attrStr = NSMutableAttributedString(string: originStr)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, originStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, originStr.count))
        alert.setValue(attrStr, forKey: "attributedMessage")

        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

}

