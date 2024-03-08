//
//  GGLDataBase.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/6/24.
//

import RealmSwift

final class GGLDataBase {
    static let shared = GGLDataBase()
    private lazy var realm: Realm = {
        let config = Realm.Configuration(schemaVersion: 0)
        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Realm initialize failed.")
        }
    }()

    func add(_ object: Object) {
        do {
            try realm.write({
                realm.add(object)
            })
        } catch {
            print(error)
        }
    }

    func insert<T>(_ object: T, to set: MutableSet<T>) {
        do {
            try realm.write({
                set.insert(object)
            })
        } catch {
            print(error)
        }
    }

    func objects<Element: RealmFetchable>(_ type: Element.Type) -> Results<Element> {
        return realm.objects(Element.self)
    }
}
