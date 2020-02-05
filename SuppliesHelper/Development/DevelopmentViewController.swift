//
//  DevelopmentViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class DevelopmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLocation(_ sender: Any) {
        let dao = DaoLocation()
        UIPasteboard.general.string = dao.getLocationReport()
        popUpWindow()
    }
    
    @IBAction func btnItem(_ sender: Any) {
        let dao = DaoItem()
        UIPasteboard.general.string = dao.getItemsReport()
        popUpWindow()
    }
    
    @IBAction func btnArea(_ sender: Any) {
        let dao = DaoArea()
        UIPasteboard.general.string = dao.getAreaReport()
        popUpWindow()
    }
    
    @IBAction func btnReport(_ sender: Any) {
        let dao = DaoRecord()
        UIPasteboard.general.string = dao.getRecordReport()
        popUpWindow()
    }
    
    @IBAction func btnCounter(_ sender: Any) {
        let dao = DaoCupCount()
        UIPasteboard.general.string = dao.getCupCountReport()
        popUpWindow()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func popUpWindow() {
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
}
