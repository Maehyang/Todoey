//
//  Category.swift
//  Todoey
//
//  Created by Maehyang Lee on 2018. 3. 7..
//  Copyright © 2018년 Maehyang Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}




