//
//  PopularArticlesFakeTests_swift.swift
//  PopularArticlesFakeTests.swift
//
//  Created by Nuzhat Zari on 18/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import XCTest
@testable import PopularArticles

class PopularArticlesFakeTests_swift: XCTestCase {

    var sut: FetchArticlesDataService!
    var response: [String: AnyObject]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = FetchArticlesDataService()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "data", ofType: "json")
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped),
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
            response = jsonResponse
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_ParseData() {
        //given
        let num_results = response["num_results"] as! Int
        let results = response["results"] as! [[String: AnyObject]]
        
        //when
        let articles = sut.parseData(results)
        
        //then
        XCTAssertEqual(articles?.count, num_results, "Didn't parse all items from fake response")
    }
    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
