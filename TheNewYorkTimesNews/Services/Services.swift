//
//  Services.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

class Service {
    
    let domain = "https://api.nytimes.com/svc/"
    let key = "pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"
    
    func getLatestAriticles(date: Date, completion: @escaping (_ arr: ResponseArticle? )->()) {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let url = "\(domain)archive/v1/\(year)/\(month).json?api-key=\(key)"
        let urlString = URL.init(string: url)
        guard let url_List = urlString else { return }
        
        AF.request(url_List, method: .get).responseJSON { (response) in
            if response.error == nil {
                guard let articlesResponse = response.data,
                    let json = try? JSON(data: articlesResponse).object,
                    let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
                }
                let datas = Mapper<ResponseArticle>().map(JSON: jsonItem)
                completion(datas)
            } else {
                completion(nil)
            }
            
        }
    }
    
}

