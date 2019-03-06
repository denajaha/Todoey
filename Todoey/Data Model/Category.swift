//
//  Category.swift
//  Todoey
//
//  Created by Denis Jahic on 28.02.19.
//  Copyright © 2019 Denis Jahic. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
}
