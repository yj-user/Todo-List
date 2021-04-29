//
//  Item.swift
//  Todo-List
//
//  Created by youngjun kim on 2021/04/29.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var time: Date?
    
    var superCategory = LinkingObjects(fromType: Category.self, property: "items")
}
