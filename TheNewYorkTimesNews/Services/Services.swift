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
        
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
        
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let month = (calendar?.component(NSCalendar.Unit.month, from: date)) ?? 10
        let year = (calendar?.component(NSCalendar.Unit.year, from: date)) ?? 2019
        
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
    
    func searchAriticles(text: String, completion: @escaping(_ arr: ResponseArticle? )->()) {
        
        let keywordFormat = text.trimmingCharacters(in: CharacterSet.whitespaces).folding(options: .diacriticInsensitive, locale: .current)
        
        let url = "\(domain)search/v2/articlesearch.json?q=\(keywordFormat)&api-key=\(key)&page=1"
        let urlString = URL.init(string: url)
        guard let url_Search = urlString else { return }
        
        AF.request(url_Search, method: .get).responseJSON { (response) in
            if response.error == nil {
                guard let searchResponse = response.data,
                    let json = try? JSON(data: searchResponse).object,
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

