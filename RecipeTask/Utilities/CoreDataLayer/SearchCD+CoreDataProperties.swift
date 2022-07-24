//
//  SearchCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-07-23.
//
//

import Foundation
import CoreData


extension SearchCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchCD> {
        return NSFetchRequest<SearchCD>(entityName: "SearchCD")
    }

    @NSManaged public var key: String?
    @NSManaged public var id: Int64

}
