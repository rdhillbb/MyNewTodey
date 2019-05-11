//
//  Category.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 11/5/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    //@objc dynamic var done: Bool = false
    
}
