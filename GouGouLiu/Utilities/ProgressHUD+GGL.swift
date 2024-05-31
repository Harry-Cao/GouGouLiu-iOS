//
//  ProgressHUD+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/25/23.
//

import Foundation

extension ProgressHUD {

    static func showServerMsg<T>(model: GGLMoyaModel<T>) where T: Codable {
        switch model.code {
        case .success:
            ProgressHUD.showSucceed(model.msg)
        case .failed:
            ProgressHUD.showFailed(model.msg)
        default:
            break
        }
    }

    static func showServerProgress(progress: Double) {
        ProgressHUD.showProgress(progress)
    }

}
