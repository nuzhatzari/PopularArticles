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
    
    func fetchArticles(completion: @escaping (APIResult<[Article]>) -> Void) {
        
        //Fetch data from Server.
        fetchData(objectType: [Article].self, completion: {(result: APIResult<[Article]>) in
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
}
