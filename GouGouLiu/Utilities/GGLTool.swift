//
//  GGLTool.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/8.
//

import Foundation

struct GGLTool {
    static func jsonStringToModel<T: Decodable>(jsonString: String, to modelType: T.Type) -> T? {
        if let data = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let model = try decoder.decode(T.self, from: data)
                return model
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        } else {
            print("Failed to convert JSON string to data.")
        }
        return nil
    }

    static func modelToJsonString<T: Encodable>(_ model: T) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                print("Failed to convert data to string.")
            }
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
        }
        return nil
    }
}
