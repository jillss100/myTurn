//
//  User+CoreDataProperties.swift
//  MyTurn
//
//  Created by Jill Uhl on 3/13/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: NSObject?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var activities: NSSet?

}

// MARK: Generated accessors for activities
extension User {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}
