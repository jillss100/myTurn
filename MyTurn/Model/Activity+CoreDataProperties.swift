//
//  Activity+CoreDataProperties.swift
//  MyTurn
//
//  Created by Jill Uhl on 1/23/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Activity {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
