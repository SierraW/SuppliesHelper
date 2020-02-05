//
//  RecordController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

class RecordController {
    var daoRecord: DaoRecord
    
    var record: ShuyiSupplyRecord!
    
    var itemSet: VisitedItemSet
    
    var sections: [ShuyiArea] = []
    
    var sectionIsolatedItem: [[Int]] = []
    
    init(at date:Date?) {
        daoRecord = DaoRecord()
        
        let daoItem = DaoItem()
        itemSet = VisitedItemSet(items: daoItem.getItem())
        
        let daoArea = DaoArea()
        sections = daoArea.getAreas()
        
        let daoLocation = DaoLocation()
        
        for i: Int in 0..<sections.count {
            sectionIsolatedItem.append(daoLocation.getLocationItemIdex(at: i))
        }
        
        if (date != nil) {
            record = daoRecord.getRecord(at: date!)
            daoRecord.loadData(itemSet: itemSet, record: record)
        } else {
            record = daoRecord.newRecord()
            itemSet.setVisited(items: sectionIsolatedItem.last!)
        }
    }
    
    func saveData() {
        daoRecord.saveData(itemSet: itemSet, record: record)
    }
    
    func visit(at index:Int) {
        itemSet.visit(at: index)
    }
    
    func unvisit(at index: Int) {
        if itemSet.visited.contains(index) {
            itemSet.unvisit(at: index)
        } else {
            visit(at: index)
        }
    }
    
    func labelItem(at index: Int) {
        if !itemSet.labeled.contains(index) {
            labelItem(at: index, value: 0)
        } else if itemSet.items[index].itemCount == 0 {
            labelItem(at: index, value: -1)
        }
    }
    
    func labelItem(at index: Int, value: Int?) {
        if value != nil, value! == -1 {
            itemSet.removeFromLabel(for: index)
            itemSet.setCount(at: index, value: nil)
        } else {
            itemSet.label(at: index)
            itemSet.setCount(at: index, value: value)
        }
    }
    
    func getItem(at index: Int, atSection secIndex: Int) -> VisitedItem {
        return itemSet.items[sectionIsolatedItem[secIndex][index]]
    }
    
    func getItem(at index: Int) -> VisitedItem{
        return itemSet.items[index]
    }
    
    func getItems(at section: Int?) -> ([Int], [Int]) {
        if section == nil {
            return (itemSet.visited, itemSet.unvisited)
        } else {
            var unvisited = sectionIsolatedItem[section!]
            var visited:[Int] = []
            var pointer = unvisited.count
            while pointer > 0 {
                pointer -= 1
                if itemSet.visited.contains(unvisited[pointer]) {
                    visited.append(unvisited.remove(at: pointer))
                }
            }
            return (visited, unvisited)
        }
    }
    
    func getOutputStr() -> String {
        var labeledItem: [VisitedItem] = []
        for labeledIndex: Int in itemSet.labeled {
            labeledItem.append(getItem(at: labeledIndex))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        var output = "\(dateFormatter.string(from: Date()))\n"
        for item: VisitedItem in labeledItem {
            if item.itemCount == 0 {
                output.append(item.shuyiItem.name! + "\n")
            } else {
                output.append(item.shuyiItem.name! + " 还剩\(item.itemCount!)\(item.shuyiItem.unit!)\n")
            }
        }
        print(output)
        return output
    }
}
