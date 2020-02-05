//
//  DaoLocation.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-30.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit
import CoreData

class DaoLocation {
    let entityName = "ShuyiItemLocation"
    var daoItem = DaoItem()
    var daoArea = DaoArea()
    
    var itemArr: [ShuyiSupplyItem]!
    var areaArr: [ShuyiArea]!
    
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    var locationArr: [ShuyiItemLocation]!
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        itemArr = daoItem.getItem()
        areaArr = daoArea.getAreas()
    }
    
    private func getLocations(predicate pre:String?) -> [ShuyiItemLocation] {
        var locations: [ShuyiItemLocation] = []
        
        let location = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let request = NSFetchRequest<ShuyiItemLocation>(entityName: entityName)
        
        request.entity = location
        
        if (pre != nil) {
            let predicate = NSPredicate(format: pre!, "")
            request.predicate = predicate
        }
        
        
        do {
            let results:[AnyObject]? = try managedObjectContext.fetch(request)
            locations = results as! [ShuyiItemLocation]
        
        } catch {
            print(error)
        }
        
        return locations
    }
    
    func getLocationObj() -> ShuyiItemLocation {
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiItemLocation
        return newLocation
    }
    
    func remove(at location: ShuyiItemLocation?) {
        if location == nil {
            for each: ShuyiItemLocation in getLocations(predicate: nil) {
                managedObjectContext.delete(each)
                save()
            }
        } else {
            managedObjectContext.delete(location!)
            save()
        }
    }
    
    func getLocationReport() -> String {
        var output = ""
        for location: ShuyiItemLocation in getLocations(predicate: nil) {
            output.append(contentsOf: "\"\(location.id_area)/\(location.id_item)\",")
        }
        return output
    }
    
    func getLocationItemIdex(at area: Int) -> [Int] {
        let locates = getLocations(predicate: "id_area = '\(area)'")
        return locates.compactMap{Int($0.id_item)}
    }
    
    public func getSetLocation(area index: Int16) -> LocationSelectionSet {
        var setLocations: [ReadableLocation] = []
        var unsetLocations: [ReadableLocation] = []
        locationArr = getLocations(predicate: "id_area= '\(index)'")
        
        for item: ShuyiSupplyItem in itemArr {
            var location = ReadableLocation(item: item)
            location.shuyiLocation = getItemLocation(forItem: item.id_item)
            if (location.shuyiLocation == nil) {
                location.atPlaces = getLocations(predicate: "id_item= '\(item.id_item)'").count
                unsetLocations.append(location)
            } else {
                setLocations.append(location)
            }
        }
        
        return LocationSelectionSet(index, setLocations, unsetLocations)
    }
    
    public func add(id_item: Int16, id_area: Int16) -> ShuyiItemLocation?{
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! ShuyiItemLocation
        newLocation.id_item = id_item
        newLocation.id_area = id_area
        do {
            try managedObjectContext.save()
        } catch {
            print("failed")
        }
        return newLocation
    }
    
    public func delete(item locationObj: ShuyiItemLocation) {
        do {
            managedObjectContext.delete(locationObj)
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    private func getItemLocation(forItem index: Int16) -> ShuyiItemLocation? {
        for location: ShuyiItemLocation in locationArr {
            if (location.id_item == index) {
                return location
            }
        }
        return nil
    }
}
