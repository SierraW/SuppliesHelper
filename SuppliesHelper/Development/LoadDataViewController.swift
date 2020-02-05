//
//  LoadDataViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-03.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class LoadDataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtData: UITextField!
    
    var version: String?
    var build: String?
    var dao: DaoShuyiApp!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dao = DaoShuyiApp()
    }
    
    func resetNotification() {
        if build != nil, version != nil {
            dao.creatNewObject(version: version!, build: build!)
        }
    }
    
    @IBAction func allData(_ sender: Any) {
        if !validateKey(txtData.text ?? "") {
            popUpWindow(notification: "读取数据失败！请检查是否有拼写错误。")
            return
        }
        let reload = DefaultData()
        reload.resetItem(dao: DaoItem())
        reload.resetArea(dao: DaoArea())
        reload.resetLocation(dao: DaoLocation())
        resetNotification()
        popUpWindow(notification: "读取数据成功")
    }
    
    @IBAction func resetItem(_ sender: Any) {
        if !validateKey(txtData.text ?? "") {
            popUpWindow(notification: "读取数据失败！请检查是否有拼写错误。")
            return
        }
        let reload = DefaultData()
        reload.resetItem(dao: DaoItem())
        resetNotification()
        popUpWindow(notification: "已重置货品数据")
    }
    
    @IBAction func resetArea(_ sender: Any) {
        if !validateKey(txtData.text ?? "") {
            popUpWindow(notification: "读取数据失败！请检查是否有拼写错误。")
            return
        }
        let reload = DefaultData()
        reload.resetArea(dao: DaoArea())
        resetNotification()
        popUpWindow(notification: "已重置区域数据")
    }
    
    @IBAction func resetMapping(_ sender: Any) {
        if !validateKey(txtData.text ?? "") {
            popUpWindow(notification: "读取数据失败！请检查是否有拼写错误。")
            return
        }
        let reload = DefaultData()
        reload.resetLocation(dao: DaoLocation())
        popUpWindow(notification: "已重置货品/区域联系数据")
    }
    
    private func validateKey(_ key: String) -> Bool {
        return key == "StlAKalxYsKu56VBH"
    }
    
    func popUpWindow(notification str: String) {
        let alert = UIAlertController(title: "提示", message: "提示", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "Dismiss", style: .default) { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
                }
        let originStr = "\(str)"
        let attrStr = NSMutableAttributedString(string: originStr)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, originStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, originStr.count))
        alert.setValue(attrStr, forKey: "attributedMessage")

        alert.addAction(sureAction)
        present(alert, animated: true, completion: nil)
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
