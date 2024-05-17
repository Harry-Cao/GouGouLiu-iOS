//
//  GGLDataBase.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/6/24.
//

import RealmSwift
import Combine

final class GGLDataBase {
    static let shared = GGLDataBase()
    private let inMemoryIdentifier: String?
    private(set) lazy var realm: Realm = {
        let config = Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier, schemaVersion: 0)
        Realm.Configuration.defaultConfiguration = config
        do {
            return try Realm()
        } catch {
            fatalError("Realm initialize failed.")
        }
    }()
    private(set) var userUpdateSubject = PassthroughSubject<GGLUserModel, Never>()
    private(set) var messageUnReadSubject = PassthroughSubject<GGLMessageModel, Never>()
    var cancellables = Set<AnyCancellable>()

    init(inMemoryIdentifier: String? = nil) {
        self.inMemoryIdentifier = inMemoryIdentifier
    }

    func startSubscribe() {
        subscribeMessage()
    }

    func write(_ action: () -> Void) {
        do {
            try realm.write {
                action()
            }
        } catch {
            print(error)
        }
    }
}
