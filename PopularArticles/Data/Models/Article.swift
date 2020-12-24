//
//  Article.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 17/12/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

class Article: NSObject, Decodable {

    @objc var id: Int = 0
    @objc var url: String = ""
    @objc var published_date: String = ""
    @objc var section: String = ""
    @objc var byline: String = ""
    @objc var title: String = ""
    @objc var adx_keywords: String = ""
    @objc var subsection: String = ""
    
    subscript(key: String) -> Any? {
           return self.value(forKey: key)
    }
}

class SearchDetail {
    var title: String = ""
    var key: String = ""
    var text: String = ""
    
    init(title: String, key: String, text: String) {
        self.title = title
        self.key = key
        self.text = text
    }
}
