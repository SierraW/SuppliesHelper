//
//  ImgContrast.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-19.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

struct ImgContrast {
    var count = 0
    var r = 0
    var g = 0
    var b = 0
    var y: Int
    var a = 0
    
    mutating func addNewMember(r red: Int, g green: Int, b blue: Int) {
        count += 1
        r = (r * (count - 1) + red) / count
        g = (g * (count - 1) + green) / count
        b = (b * (count - 1) + blue) / count
    }
}
