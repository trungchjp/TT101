//
//  Article.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseArticle: Mappable {
    
    var copyright: String = ""
    var response: ResponseDetailArticle!
    
    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        copyright <- map["copyright"]
        response <- map["response"]
    }
}


class ResponseDetailArticle: Mappable {
    var meta: Meta!
    var docs:[Document] = []
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        meta <- map["meta"]
        docs <- map["docs"]
    }
}

class Meta: Mappable {
    var hits: Int = 0
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        hits <- map["hits"]
    }
}
