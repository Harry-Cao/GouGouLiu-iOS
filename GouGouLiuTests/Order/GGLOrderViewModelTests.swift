//
//  GGLOrderViewModelTests.swift
//  GouGouLiuTests
//
//  Created by harry.weixian.cao on 2024/8/28.
//

import XCTest
@testable import GouGouLiu

final class GGLOrderViewModelTests: XCTestCase {
    private let orderViewModel = GGLOrderViewModel()

    func testItemCount_withIPhone_shouldEqual1() {
        let screenWidths: [CGFloat] = [10, 500]
        screenWidths.forEach {
            let itemCount = orderViewModel.itemCount(screenWidth: $0)
            XCTAssertEqual(itemCount, 1)
        }
    }

    func testItemCount_withIPad_shouldEqual2() {
        let screenWidths: [CGFloat] = [744, 900]
        screenWidths.forEach {
            let itemCount = orderViewModel.itemCount(screenWidth: $0)
            XCTAssertEqual(itemCount, 2)
        }
    }

    func testItemCount_withBigScreen_shouldGreaterThan2() {
        let screenWidths: [CGFloat] = [1024, 2000]
        screenWidths.forEach {
            let itemCount = orderViewModel.itemCount(screenWidth: $0)
            XCTAssertTrue(itemCount >= 3)
        }
    }
}
