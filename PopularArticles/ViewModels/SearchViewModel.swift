//
//  SearchViewModel.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 19/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {

    var searchDetails = [SearchDetail]()
    var articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    func createSearchCriteria() -> [SearchDetail] {
        let searchDetailObj1 = SearchDetail(title: "Section", key: "section", text: "")
        searchDetails.append(searchDetailObj1)
        
        let searchDetailObj2 = SearchDetail(title: "Subsection", key: "subsection", text: "")
        searchDetails.append(searchDetailObj2)
        return searchDetails
    }
    
    
    func fetchOptions(for key: String) -> [String] {
        var options = [String]()
        
        _ = articles.filter { (article: Article) -> Bool in
            
            guard options.contains(article[key] as! String) == false else {
                return false
            }
            options.append(article[key] as! String)
            return true
        }
        return options
    }
}
