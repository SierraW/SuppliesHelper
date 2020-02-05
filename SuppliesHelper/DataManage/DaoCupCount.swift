//
//  DaoCupCount.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-05.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoCupCount {
    let entityName = "ShuyiCupHistory"
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func newCupCount(previous record: ShuyiCupHistory?) -> ShuyiCupHistory {
        let cupCount = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiCupHistory
        cupCount.date = Date()
        
        cupCount.morning = "0/0/0/0/0/0/0/0"
        cupCount.night = "0/0/0/0/0/0/0/0"
        
        if record != nil {
            let timeInterval = cupCount.date.timeIntervalSince(record!.date)
            if timeInterval < (36*60*60) {
                cupCount.morning = record!.night
            }
        }
        
        return cupCount
    }
    
    func getCupCounts(predicate date: Date?) -> [ShuyiCupHistory]? {
        var shuyiCupHistory: [ShuyiCupHistory] = []
        
        let cupCount = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiCupHistory>(entityName: entityName)
        
        request.entity = cupCount
        
        if (date != nil) {
            let predicate = NSPredicate(format: "date < %@", date! as NSDate)
            request.predicate = predicate
        }
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            shuyiCupHistory = results as! [ShuyiCupHistory]
        } catch {
            return nil
        }
        
        return shuyiCupHistory
    }
    
    func getCupCount(at date: Date) -> ShuyiCupHistory? {
        let result = getCupCounts(predicate: date)
        if result != nil {
            if result!.count != 0, isSameDay(day: date, record: result!.last!.date) {
                return result!.last!
            }
            return newCupCount(previous: result!.last)
        }
        return newCupCount(previous: nil)
    }
    
    func writeData(morningData: [Int?], nightData: [Int?], record: ShuyiCupHistory) {
        var morning = ""
        var night = ""
        for i in 0..<nightData.count {
            morning.append("\(morningData[i] ?? 0)/")
            night.append("\(nightData[i] ?? 0)/")
        }
        record.morning = morning
        record.night = night
        save()
    }
    
    func readData(record: ShuyiCupHistory) -> (morning: [Int], night: [Int]) {
        let morning = record.morning.split(separator: "/").compactMap{Int("\($0)")}
        let night = record.night.split(separator: "/").compactMap{Int("\($0)")}
        
        return (morning, night)
    }
    
    func remove(at cupCount: ShuyiCupHistory?) {
        if let record = getCupCounts(predicate: nil) {
            if cupCount == nil {
                for countItem: ShuyiCupHistory in record {
                    managedObjectContext.delete(countItem)
                    save()
                }
            } else {
                managedObjectContext.delete(cupCount!)
                save()
            }
        }
    }
    
    func getCupCountReport() -> String {
        var output = ""
        if let allCount = getCupCounts(predicate: nil) {
            for record: ShuyiCupHistory in allCount {
                output.append("\"\(record.date),\(record.morning),\(record.night)\",")
            }
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
    
    func isSameDay(day date0: Date, record date1: Date) -> Bool {
        let timeInterval = date0.timeIntervalSince(date1)
        if timeInterval < 5*60*60 && timeInterval > -(5*60*60) {
            return true
        }
        return false
    }
}
