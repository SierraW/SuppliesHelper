//
//  AreaEditViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-03.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class AreaEditViewController: UIViewController, UITextFieldDelegate {
    
    var area: ShuyiArea?
    var dao: DaoArea!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblId: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = area?.name ?? "New Location"
        
        if area == nil {
            area = dao.getAreaObject()
            area!.name = "New Location"
        }
        
        lblId.text = "\(area!.id_area)"
        txtName.text = area!.name
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func txtEdit(_ sender: Any) {
        view.endEditing(true)
        area!.name = txtName.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        area!.name = txtName.text
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
