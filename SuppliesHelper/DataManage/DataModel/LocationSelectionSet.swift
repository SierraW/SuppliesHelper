//
//  LocationSelectionSet.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-01.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

class LocationSelectionSet {
    var areaIndex: Int16!
    var setLocationItems: [ReadableLocation]!
    var unsetLocationItems: [ReadableLocation]!
    
    init(_ index: Int16, _ set: [ReadableLocation],_ unset: [ReadableLocation]) {
        self.areaIndex = index
        self.setLocationItems = set
        self.unsetLocationItems = unset
    }
    
    func seletcItem(at index: Int, dao: DaoLocation) {
        var item = unsetLocationItems.remove(at: index)
        item.shuyiLocation = dao.add(id_item: item.shuyiItem.id_item, id_area: areaIndex)
        
        setLocationItems.append(item)
    }
    
    func deselectItem(at index: Int, dao: DaoLocation) {
        var item = setLocationItems.remove(at: index)
        dao.delete(item: item.shuyiLocation!)
        item.shuyiLocation = nil
        unsetLocationItems.append(item)
    }
}
