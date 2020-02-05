//
//  DaoShuyiApp.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-05.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoShuyiApp {
    let entityName = "ShuyiApp"
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func checkNotification(version str: String, build value: String) -> Bool {
        let records = getRecord()
        if records != nil, records!.count > 0 {
            let lastRecord = records!.last!
            if lastRecord.build == value {
                return true
            }
        }
        return false
    }
    
    func creatNewObject(version str: String, build value: String) {
        let newObj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiApp
        newObj.date = Date()
        newObj.version = str
        newObj.build = value
        save()
    }
    
    func getRecord() -> [ShuyiApp]? {
        var shuyiAppRecord: [ShuyiApp] = []
        
        let record = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiApp>(entityName: entityName)
        
        request.entity = record
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            shuyiAppRecord = results as! [ShuyiApp]
        } catch {
            return nil
        }
        
        return shuyiAppRecord
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}
