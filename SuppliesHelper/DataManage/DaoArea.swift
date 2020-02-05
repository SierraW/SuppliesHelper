//
//  DaoArea.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-28.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoArea {
    
    let entityName = "ShuyiArea"
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
    }
    
    func getAreas() -> [ShuyiArea] {
        
        var shuyiAreas: [ShuyiArea] = []
        
        let area = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiArea>(entityName: entityName)
        
        request.entity = area
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            shuyiAreas = results as! [ShuyiArea]
        } catch {
            print(error)
        }
        
        return shuyiAreas
    }
    
    func getAreaObject() -> ShuyiArea {
        let newArea = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiArea
        newArea.id_area = nextAvailble("id_area", forEntityName: entityName, in: managedObjectContext) as! Int16
        return newArea
    }
    
    func remove(at area: ShuyiArea?) {
        if area == nil {
            for each: ShuyiArea in getAreas() {
                managedObjectContext.delete(each)
                save()
            }
        } else {
            managedObjectContext.delete(area!)
            save()
        }
    }
    
    func getAreaReport() -> String {
        //"0/书亦店面",
        let allAreas = getAreas()
        var output = ""
        for area: ShuyiArea in allAreas {
            output.append("\"\(area.id_area)/\(area.name!)\",")
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
