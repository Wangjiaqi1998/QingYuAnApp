//
//  PoemEntity+CoreDataProperties.swift
//  PoetryFinal
//
//  Created by 王嘉祺 on 12/26/19.
//  Copyright © 2019 王嘉祺. All rights reserved.
//
//

import Foundation
import CoreData


extension PoemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PoemEntity> {
        return NSFetchRequest<PoemEntity>(entityName: "PoemEntity")
    }

    @NSManaged public var id: Int64 

}
