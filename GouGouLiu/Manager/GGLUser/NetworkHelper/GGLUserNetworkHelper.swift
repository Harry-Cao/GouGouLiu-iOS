//
//  GGLUserNetworkHelper.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation
import Combine
import Moya

final class GGLUserNetworkHelper {
    private let provider = MoyaProvider<GGLUserAPI>()
    private var cancellables = Set<AnyCancellable>()

    func requestSignup(username: String, password: String, isSuper: Bool, completion: @escaping (GGLMoyaModel<GGLUserModel>) -> Void) {
        provider.requestPublisher(.signUp(username: username, password: password, isSuper: isSuper))
            .map(GGLMoyaModel<GGLUserModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestLogin(username: String, password: String, completion: @escaping (GGLMoyaModel<GGLLoginModel>) -> Void) {
        provider.requestPublisher(.login_n_pw(username: username, password: password))
            .map(GGLMoyaModel<GGLLoginModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestLogin(userId: String, completion: @escaping (GGLMoyaModel<GGLLoginModel>) -> Void) {
        provider.requestPublisher(.login_id(userId: userId))
            .map(GGLMoyaModel<GGLLoginModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestLogout(userId: String, completion: @escaping (GGLMoyaModel<GGLUserModel>) -> Void) {
        provider.requestPublisher(.logout(userId: userId))
            .map(GGLMoyaModel<GGLUserModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestClearAll(userId: String, completion: @escaping (GGLMoyaModel<GGLUserModel>) -> Void) {
        provider.requestPublisher(.clearAll(userId: userId))
            .map(GGLMoyaModel<GGLUserModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestAllUsers(userId: String, completion: @escaping (GGLMoyaModel<[GGLUserModel]>) -> Void) {
        provider.requestPublisher(.allUsers(userId: userId))
            .map(GGLMoyaModel<[GGLUserModel]>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func requestGetUser(userId: String, completion: @escaping (GGLMoyaModel<GGLUserModel>) -> Void) {
        provider.requestPublisher(.getUser(userId: userId))
            .map(GGLMoyaModel<GGLUserModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

}
