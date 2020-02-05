//
//  ReadableLocation.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-30.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

struct ReadableLocation {
    var shuyiLocation: ShuyiItemLocation?
    var shuyiItem: ShuyiSupplyItem!
    var atPlaces: Int?
    
    init(item shuyiItem: ShuyiSupplyItem) {
        self.shuyiItem = shuyiItem
    }
}
