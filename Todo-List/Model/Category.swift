//
//  Category.swift
//  Todo-List
//
//  Created by youngjun kim on 2021/04/29.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    var items = List<Item>()
}
