//
//  GGLNetworkManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import Foundation
import Alamofire

final class GGLNetworkManager {

    var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    private let networkManager = NetworkReachabilityManager(host: GGLAPI.host)
    static let shared = GGLNetworkManager()

    func startListening() {
        networkManager?.startListening(onUpdatePerforming: { status in
            self.networkStatus = status
            NotificationCenter.default.post(name: .networkStatusUpdated, object: nil)
        })
    }

    func stopListening() {
        networkManager?.stopListening()
    }

}
