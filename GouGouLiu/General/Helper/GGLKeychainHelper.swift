//
//  GGLKeychainHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import Foundation
import Security

struct GGLKeychainHelper {

    // 添加或更新Keychain条目
    static func save(key: GGLKeychainKey, data: Data, service: String = "DefaultService") -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ] as [String : Any]

        SecItemDelete(query as CFDictionary) // 尝试删除旧值
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // 从Keychain中检索数据
    static func load(key: GGLKeychainKey, service: String = "DefaultService") -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data {
            return data
        }
        return nil
    }

    // 删除Keychain中的数据
    static func delete(key: GGLKeychainKey, service: String = "DefaultService") -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ] as [String : Any]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

}

extension GGLKeychainHelper {
    enum GGLKeychainKey: String {
        case userToken
    }

    static var userToken: String? {
        get {
            if let loadedData = load(key: .userToken),
               let token = String(data: loadedData, encoding: .utf8) {
                return token
            }
            return nil
        }
        set {
            guard let data = newValue?.data(using: .utf8) else { return }
            let _ = save(key: .userToken, data: data)
        }
    }
}

