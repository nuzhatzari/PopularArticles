//
//  PopularArticlesUITests.swift
//  PopularArticlesUITests
//
//  Created by Nuzhat Zari on 24/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import XCTest

class PopularArticlesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()

        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWebView() throws {
        // UI tests must launch the application that they test.
        //given
        let cell = app.tables.cells.element(boundBy: 0)
        //staticTexts["By Ben Smith"]
            
        
        //then
        cell.tap()
        sleep(2)
        let webview = app.webViews["webView"]
        XCTAssert(webview.exists, "Webview did not load.")
        sleep(2)
        app.buttons["detail_back"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        /*
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: webview, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(webview.exists, "Webview did not load.")*/
    }

    func testSearch() throws {
        // UI tests must launch the application that they test.
        //given
        let search_btn = app.buttons["search_button"]
        //staticTexts["By Ben Smith"]
            
        //then
        search_btn.tap()
        sleep(2)
        let option_btn = app.tables.cells.element(boundBy: 0).buttons.element(boundBy: 0)
        option_btn.tap()
        
        let picker = app.pickers["option_picker"]
        XCTAssert(picker.exists, "Picker did not load.")
        sleep(2)
        
        let done_btn = app.buttons["option_done"]
        done_btn.tap()
        
        sleep(2)
        app.buttons["search_done_btn"].tap()
                
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        /*
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: webview, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(webview.exists, "Webview did not load.")*/
    }
    
    func testSearchBack() throws {
        //given
        let search_btn = app.buttons["search_button"]

        //then
        search_btn.tap()
        sleep(2)
        
        app.buttons["close_search_btn"].tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
