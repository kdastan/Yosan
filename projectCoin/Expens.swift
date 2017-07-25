//
//  Categories.swift
//  projectCoin
//
//  Created by Apple on 19.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation
import RealmSwift

class Expens: Object {
    
//    dynamic var objectID = UUID().uuidString
    dynamic var amount = 0
    dynamic var date = ""
    dynamic var categories = ""
//    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
}
