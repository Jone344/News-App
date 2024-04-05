//
//  NewsData+CoreDataProperties.swift
//  
//
//  Created by user on 05.04.24.
//
//

import Foundation
import CoreData


extension NewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsData> {
        return NSFetchRequest<NewsData>(entityName: "NewsData")
    }

    @NSManaged public var link: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var source: String?

}
