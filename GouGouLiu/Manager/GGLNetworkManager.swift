//
//  GGLNetworkManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import Foundation
import Alamofire
import Combine

final class GGLNetworkManager {

    @Published private(set) var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    private let networkManager = NetworkReachabilityManager(host: GGLAPI.host)
    static let shared = GGLNetworkManager()

    func startListening() {
        networkManager?.startListening(onUpdatePerforming: { status in
            self.networkStatus = status
        })
    }

    func stopListening() {
        networkManager?.stopListening()
    }

}
