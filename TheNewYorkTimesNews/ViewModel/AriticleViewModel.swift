//
//  AriticleViewModel.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AriticleViewModel: NSObject {
     
    let ariticles = BehaviorRelay<Date>.init(value: Date())
    let ariticlesSearch = BehaviorRelay<String>.init(value: "")
    
    let getAriticle = BehaviorRelay<[CustomData]>.init(value: [])
    let getAriticlesSearch = BehaviorRelay<[CustomData]>(value: [])
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func getArticles() {
        ariticles.subscribe(onNext: { (date) in
            Service().getLatestAriticles(date: date) { [weak self] (response) in
                if let data = response {
                    let section = CustomData.init(items: data.response.docs)
                    self?.getAriticle.accept([section])
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func searchArticles() {
        ariticlesSearch.asObservable().subscribe(onNext: { (param) in
            if param.count <= 0 || param.isEmpty {return}
            Service().searchAriticles(text: param) { [weak self] (response) in
                if let data = response?.response {
                    let section = CustomData.init(items: data.docs)
                    self?.getAriticlesSearch.accept([section])
                }
            }
        }).disposed(by: disposeBag)
    }
}

