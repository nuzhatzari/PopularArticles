//
//  PopularArticlesSearchTests.swift
//  PopularArticlesSearchTests
//
//  Created by Nuzhat Zari on 18/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import XCTest
@testable import PopularArticles

class PopularArticlesSearchTests: XCTestCase {
    var sut: ViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = ViewModel()
        
       //Article1
        var articles = [Article]()
        let article1 = Article()
        article1.id = 100000007482952
        article1.url = "https://www.nytimes.com/2020/12/11/arts/music/fka-twigs-shia-labeouf-abuse.html"
        article1.published_date = "2020-12-11"
        article1.section = "Arts"
        article1.byline = "By Katie Benner and Melena Ryzik"
        article1.title = "FKA twigs Sues Shia LaBeouf, Citing ‘Relentless’ Abusive Relationship"
        article1.adx_keywords = "Suits and Litigation (Civil);Domestic Violence;Sex Crimes;#MeToo Movement;internal-storyline-no;FKA twigs;LaBeouf, Shia"
        article1.subsection = "Music"
        articles.append(article1)
        
        //Article2
        let article2 = Article()
        article2.id = 100000007497420
        article2.url = "https://www.nytimes.com/2020/12/13/us/politics/trump-allies-election-overturn-congress-pence.html"
        article2.published_date = "2020-12-13"
        article2.section = "U.S."
        article2.byline = "By Nicholas Fandos and Michael S. Schmidt"
        article2.title = "Trump Allies Eye Long-Shot Election Reversal in Congress, Testing Pence"
        article2.adx_keywords = "Presidential Election of 2020;Biden, Joseph R Jr;Trump, Donald J;Pence, Mike;Democratic Party;Republican Party;House of Representatives"
        article2.subsection = "Politics"
        articles.append(article2)
        
        
        //Article3
        let article3 = Article()
        article3.id = 100000007497882
        article3.url = "https://www.nytimes.com/2020/12/11/us/politics/supreme-court-election-texas.html"
        article3.published_date = "2020-12-11"
        article3.section = "U.S."
        article3.byline = "By Adam Liptak"
        article3.title = "Supreme Court Rejects Texas Suit Seeking to Subvert Election"
        article3.adx_keywords = "Presidential Election of 2020;States (US);Attorneys General;Suits and Litigation (Civil);Voter Fraud (Election Fraud);Presidential Transition (US);Electoral College;Decisions and Verdicts;United States Politics and Government;Federal-State Relations (US);Biden, Joseph R Jr;Trump, Donald J;Paxton, Ken;Supreme Court (US);Texas"
        article3.subsection = "Politics"
        articles.append(article3)
        sut.articles = articles
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func test_SearchArticle() {
        // given
        let searchDetails = SearchDetail(title: "Section", key: "section", text: "U.S.")
        
        //when
        let articles = sut.filterDataBasedOnSearch("Election", [searchDetails])
        
        //then
        XCTAssertEqual(articles.count, 2, "Search function returned wrong values")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.

        measure {
            // Put the code you want to measure the time of here.
            self.sut.fetchArticleData()
        }
    }

}
