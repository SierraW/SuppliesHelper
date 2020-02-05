//
//  RecordNaviViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class RecordNaviViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    
    var version: String!
    var build: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "介绍")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        navigationItem.title = "Supplies Helper"
        
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        
        lblVersion.text = "\(now()) ver\(version ?? "1.0")(\(build ?? "error"))"
        
        //check notification
        let daoApp = DaoShuyiApp()
        if !daoApp.checkNotification(version: version, build: build) {
            popUpWindow(version: version, build: build, daoShuyiApp: daoApp)
        }
    }
    
    func popUpWindow(version: String, build: String, daoShuyiApp dao: DaoShuyiApp){
        let alert = UIAlertController(title: "欢迎！", message: "Delete Data", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "忽略", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let gotoAction = UIAlertAction(title: "前往Data Source更新", style: .default, handler: { (alert: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "Reset Shortcut", sender: nil)
        } )
        let ignoreAction = UIAlertAction(title: "不再提醒", style: .destructive, handler: {
            [weak self] _ in
            dao.creatNewObject(version: version, build: build)
            self?.navigationController?.popViewController(animated: true)
        })
        
        let str = "更新软件之后，别忘了更新您的数据库噢！"
        let attrStr = NSMutableAttributedString(string: str)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, str.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, str.count))
        alert.setValue(attrStr, forKey: "attributedMessage")
        
        alert.addAction(gotoAction)
        
        alert.addAction(cancelAction)
        
        alert.addAction(ignoreAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func newRecord(_ sender: Any) {
        performSegue(withIdentifier: "To Record Detail", sender: sender)
    }
    
    private func now() -> String {
        let gmtNow = Date()
//        let interval = NSTimeZone.system.secondsFromGMT()
//        let now = gmtNow.addingTimeInterval(TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        return dateFormatter.string(from: gmtNow)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rlstvc = segue.destination as? RecordLocationSelectionTableViewController {
            rlstvc.controller = RecordController(at: nil)
        }
        if let ldvc = segue.destination as? LoadDataViewController {
            ldvc.version = version
            ldvc.build = build
        }
    }

}
