//
//  GGLDataBase.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/6/24.
//

import RealmSwift
import RxSwift

final class GGLDataBase {
    static let shared = GGLDataBase()
    private(set) lazy var realm: Realm = {
        let config = Realm.Configuration(schemaVersion: 0)
        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Realm initialize failed.")
        }
    }()
    private(set) var userUpdateSubject = PublishSubject<GGLUserModel>()
    private(set) var messageUnReadSubject = PublishSubject<GGLMessageModel>()
    private(set) var disposeBag = DisposeBag()
    private(set) lazy var userNetworkHelper = GGLUserNetworkHelper()

    func startSubscribe() {
        subscribeMessage()
    }

    func add(_ object: Object) {
        write {
            realm.add(object)
        }
    }

    func delete(_ object: Object) {
        write {
            realm.delete(object)
        }
    }

    func insert<T>(_ object: T, to set: MutableSet<T>) {
        write {
            set.insert(object)
        }
    }

    func write(_ action: () -> Void) {
        do {
            try realm.write({
                action()
            })
        } catch {
            print(error)
        }
    }
}
