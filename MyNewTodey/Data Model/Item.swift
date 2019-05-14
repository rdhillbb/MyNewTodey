//
//  Item.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 11/5/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parenetCategory = LinkingObjects(fromType: Category.self, property: "items")
}
