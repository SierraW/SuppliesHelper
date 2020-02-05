//
//  ShuyiCupHistory+CoreDataProperties.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-05.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//
//

import Foundation
import CoreData


extension ShuyiCupHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShuyiCupHistory> {
        return NSFetchRequest<ShuyiCupHistory>(entityName: "ShuyiCupHistory")
    }

    @NSManaged public var date: Date
    @NSManaged public var morning: String
    @NSManaged public var night: String

}
