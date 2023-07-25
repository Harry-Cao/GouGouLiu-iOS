//
//  UserDefaults+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/20/23.
//

import Foundation

extension UserDefaults {

    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserDefaults_userId")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_userId")
        }
    }

}

extension UserDefaults {

    func setObject<Object>(_ object: Object, forKey: String) where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            print(error)
        }
    }

    func getObject<Object>(forKey: String, type: Object.Type) -> Object? where Object: Decodable {
        guard let data = data(forKey: forKey) else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print(error)
        }
        return nil
    }

}
