//
//  DataManager.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    func add(meteor: Object) {
        let realm = try? Realm()
        try! realm?.write {
            realm?.add(meteor)
        }
    }
    
    func update(updateBlock: () -> ()) {
        let realm = try? Realm()
        try! realm?.write(updateBlock)
    }
    
    func delete(meteor: Object) {
        let realm = try? Realm()
        try! realm?.write {
            realm?.delete(meteor)
        }
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func objects<T: Object>(type: T.Type) -> Results<T>? {
        let realm = try? Realm()
        
        return realm?.objects(type)
    }
}
