//
//  ToDoIOSAppTests2LaunchTests.swift
//  ToDoIOSAppTests2
//
//  Created by Ekaterina Saveleva on 06.06.2025.
//

import XCTest

final class ToDoIOSAppTests2LaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
