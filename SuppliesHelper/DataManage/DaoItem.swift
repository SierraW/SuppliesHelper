//
//  DaoItem.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-28.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoItem {

    let entityName = "ShuyiSupplyItem"
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!

    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }

    func getItem() -> [ShuyiSupplyItem]{
        
        var arrItem: [ShuyiSupplyItem] = []
        
        let area = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiSupplyItem>(entityName: entityName)
        
        request.entity = area
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            
            arrItem = results as! [ShuyiSupplyItem]
        } catch {
        }
        return arrItem
    }
    
    func getItems(predicate str: String) -> [ShuyiSupplyItem] {
        var arrItem: [ShuyiSupplyItem] = []
        
        let area = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiSupplyItem>(entityName: entityName)
        
        request.entity = area
        
        let predicate = NSPredicate(format: "name contains %@", str)
        
        request.predicate = predicate
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            
            arrItem = results as! [ShuyiSupplyItem]
        } catch {
        }
        return arrItem
    }
        
    func getItemObject() -> ShuyiSupplyItem {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiSupplyItem
        newItem.id_item = nextAvailble("id_item", forEntityName: entityName, in: managedObjectContext) as! Int16
        return newItem
    }
    
    func remove(for item: ShuyiSupplyItem?) {
        if item == nil {
            for each: ShuyiSupplyItem in getItem() {
                managedObjectContext.delete(each)
                save()
            }
        } else {
            managedObjectContext.delete(item!)
            save()
        }
    }
    
    func getItemsReport() -> String {
        let allItmes = getItem()
        var output = ""
        for item: ShuyiSupplyItem in allItmes {
            output.append("\"\(item.id_item)/\(item.name!)/\(item.unit!)\",")
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
        
    // MARK: nextAvailable

    func nextAvailble(_ idKey: String, forEntityName entityName: String, in context: NSManagedObjectContext) -> NSNumber? {

        let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        req.entity = entity
        req.fetchLimit = 1
        req.propertiesToFetch = [idKey]
        let indexSort = NSSortDescriptor.init(key: idKey, ascending: false)
        req.sortDescriptors = [indexSort]

        do {
            let fetchedData = try context.fetch(req)
            if let foundValue = (fetchedData.first as! NSManagedObject).value(forKey: idKey) as? NSNumber {
                return NSNumber.init(value: foundValue.intValue + 1)
        }

        } catch {
            print(error)
        }
        return nil

    }

}
