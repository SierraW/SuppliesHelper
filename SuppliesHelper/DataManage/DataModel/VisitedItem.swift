//
//  VisitedItem.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

struct VisitedItem {
    var shuyiItem: ShuyiSupplyItem

    var itemCount: Int?
    
    init(item: ShuyiSupplyItem) {
        shuyiItem = item
    }
}
