//
//  ViewModel.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 19/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

class ViewModel: NSObject {

    var articles : [Article]?
    
    var notifyFetchArticleCompletionToController : ((_ articles: [Article]?, _ errorMsg: APPError?) -> ()) = {_,_ in }
    
    override init() {
        super.init()
    }
    
    func fetchArticleData() {
        let service = FetchArticlesDataService()
        
        service.fetchArticles {[weak self] (result: APIResult<[Article]>) in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .failure(let error):
                strongSelf.notifyFetchArticleCompletionToController(nil, error)
                
            case .success(let articles):
                strongSelf.articles = articles
                strongSelf.notifyFetchArticleCompletionToController(articles, nil)
            }
        }
    }
    
    
    func filterDataBasedOnSearch(_ searchText: String, _ searchDetails: [SearchDetail]) -> [Article] {
        
        guard (articles != nil) else {
            return []
        }
        
        var filterDataBasedOnSearchText = articles
        if searchText.count > 0 {
            filterDataBasedOnSearchText = articles!.filter { (article: Article) -> Bool in
                if article.adx_keywords.localizedCaseInsensitiveContains(searchText) {
                    return true
                } else {
                    return false
                }
            }
        }
                
        return filterDataBasedOnSearchText?.filter({ (article: Article) -> Bool in
            var present = true
            for search in searchDetails {
                if search.text.count > 0 {
                    if (article[search.key] as! String).caseInsensitiveCompare(search.text) == ComparisonResult.orderedSame {
                        present = true
                    } else {
                        present = false
                        break
                    }
                }
            }
            return present
        }) ?? []
    }
}
