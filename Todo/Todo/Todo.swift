//
//  File.swift
//  Todo
//
//  Created by Petrus on 6/12/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import Foundation
import RealmSwift

class Todo : Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var created: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

// MARK: - CRUD methods
extension Todo {
    static func allTodos(in realm: Realm = try! Realm()) -> Results<Todo> {
        let sortProperties: [SortDescriptor] = [
            SortDescriptor(keyPath: "completed", ascending: true),
            SortDescriptor(keyPath: "created", ascending: false),
            SortDescriptor(keyPath: "title", ascending: true)
        ]
        return realm
            .objects(Todo.self)
            .sorted(by: sortProperties)
    }
    
    static func add(title: String, in realm: Realm = try! Realm()) {
        let item = Todo(title: title)
        try! realm.write {
            realm.add(item)
        }
    }
    
    func delete(in realm: Realm = try! Realm()) {
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func update(title: String, completed: Bool, in realm: Realm = try! Realm()) {
        try! realm.write {
            self.title = title
            self.completed = completed
        }
    }
}
