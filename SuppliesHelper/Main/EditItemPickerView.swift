//
//  EditItemPickerView.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-29.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class EditItemPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var areas: [ShuyiArea]?
    var currentSelection: ShuyiArea?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if areas != nil {
            return areas!.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if areas != nil {
            return areas![row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if areas != nil {
            currentSelection = areas![row]
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
