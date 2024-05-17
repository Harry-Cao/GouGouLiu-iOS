//
//  GGLDataBaseTests.swift
//  GouGouLiuTests
//
//  Created by HarryCao on 2024/5/17.
//

import XCTest
@testable import GouGouLiu

final class GGLDataBaseTests: XCTestCase {
    private var database: GGLDataBase!

    override func setUpWithError() throws {
        database = GGLDataBase(inMemoryIdentifier: "TestRealm")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveOrUpdateUser() {
        let userId = "123456"
        database.deleteAllUsers()
        let emptyResult = database.fetchUser(userId)
        XCTAssertNil(emptyResult)

        let user = GGLUserModel()
        user.userId = userId
        database.saveOrUpdateUser(user)
        let fetchResult = database.fetchUser(userId)
        XCTAssertNotNil(fetchResult)
        XCTAssertNil(fetchResult?.userName)

        let username = "username"
        let updateUser = GGLUserModel()
        updateUser.userId = userId
        updateUser.userName = username
        database.saveOrUpdateUser(updateUser)
        let updatedResult = database.fetchUser(userId)
        XCTAssertNotNil(updatedResult)
        XCTAssertNotNil(updatedResult?.userName)
    }

}
