//
//  FetchArticlesData.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 17/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

class FetchArticlesDataService: NetworkManager {
    
    var period: String = "7"
    var route: String {
           get { return "mostviewed/all-sections/\(period)" } set{}
    }
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        //Fetch data from Server.
        fetchData(parse: { (data: Any) -> [Article]? in
            return self.parseData(data)

        }, completion: completion)
        
    }
    
    func parseData(_ baseResponse: Any) -> [Article]? {
        
        var articles = [Article]()
        if let articlesData = baseResponse as? Array<Dictionary<String, Any>> {
            for articleData in articlesData {
                
                let article = Article()
                if let id = articleData["id"] as? Int {
                    article.id = id
                }
                if let url = articleData["url"] as? String {
                    article.url = url
                }
                if let published_date = articleData["published_date"] as? String {
                    article.published_date = published_date
                }
                if let section = articleData["section"] as? String {
                    article.section = section
                }
                if let byline = articleData["byline"] as? String {
                    article.byline = byline
                }
                if let title = articleData["title"] as? String {
                    article.title = title
                }
                if let adx_keywords = articleData["adx_keywords"] as? String {
                    article.adx_keywords = adx_keywords
                }
                if let subsection = articleData["subsection"] as? String {
                    article.subsection = subsection
                }
                
                articles.append(article)
            }
        }
        return articles
    }
}
