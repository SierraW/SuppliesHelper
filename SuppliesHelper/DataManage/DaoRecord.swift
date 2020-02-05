//
//  DaoRecord.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoRecord {
    let entityName = "ShuyiSupplyRecord"
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func newRecord() -> ShuyiSupplyRecord {
        let record = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiSupplyRecord
        record.date = Date()
        return record
    }
    
    func getRecords(predicate date: Date?) -> [ShuyiSupplyRecord] {
        var shuyiRecord: [ShuyiSupplyRecord] = []
        
        let record = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiSupplyRecord>(entityName: entityName)
        
        request.entity = record
        
        if (date != nil) {
            let predicate = NSPredicate(format: "date = %@", date! as NSDate)
            request.predicate = predicate
        }
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            shuyiRecord = results as! [ShuyiSupplyRecord]
        } catch {
            print(error)
        }
        
        return shuyiRecord
    }
    
    func getRecord(at date: Date) -> ShuyiSupplyRecord? {
        let result = getRecords(predicate: date)
        if result.count > 0 {
            return result[0]
        } else {
            return nil
        }
    }
    
    func remove(at record: ShuyiSupplyRecord?) {
        if record == nil {
            for reocrdItem: ShuyiSupplyRecord in getRecords(predicate: nil) {
                managedObjectContext.delete(reocrdItem)
                save()
            }
        } else {
            managedObjectContext.delete(record!)
            save()
        }
    }
    
    func getRecordReport() -> String {
        let allRecords = getRecords(predicate: nil)
        var output = ""
        for record: ShuyiSupplyRecord in allRecords {
            output.append("\"\(record.date!),\(record.vis ?? ""),\(record.lab ?? "")\",")
        }
        return output
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func saveData(itemSet input: VisitedItemSet, record: ShuyiSupplyRecord) {
        record.vis = buildVis(items: input.visited)
        record.lab = buildLab(items: input.labeled.compactMap{input.items[$0]})
        save()
    }
    
    func loadData(itemSet output: VisitedItemSet, record: ShuyiSupplyRecord) {
        output.setVisited(items: loadVis(rawData: record.vis))
        output.setLabeled(items: loadLab(rawData: record.lab))
    }
    
    private func loadLab(rawData str: String?) -> [(item: Int, count: Int)] {
        if str == nil {
            return []
        }
        var output: [(Int, Int)] = []
        let block = str!.split(separator: "/").compactMap{"\($0)"}
        for item: String in block {
            let intArr = item.split(separator: ":").compactMap{Int($0)}
            output.append((intArr[0], intArr[1]))
        }
        return output
    }
    
    private func loadVis(rawData str: String?) -> [Int] {
        if str == nil {
            return []
        }
        let intArr = str!.split(separator: "/").compactMap{Int($0)}
        return intArr
    }
    
    private func buildLab(items objs: [VisitedItem]) -> String {
        var output = ""
        for item: VisitedItem in objs {
            output.append("\(item.shuyiItem.id_item):\(item.itemCount ?? 0)/")
        }
        return output
    }
    
    private func buildVis(items indexes: [Int]) -> String{
        var output = ""
        for index: Int in indexes {
            output.append("\(index)/")
        }
        return output
    }
 }
