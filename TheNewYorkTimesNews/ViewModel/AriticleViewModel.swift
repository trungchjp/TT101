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
    
    let getAriticle = BehaviorRelay<[Document]>.init(value: [])
    let getAriticlesSearch = BehaviorRelay<[Document]>(value: [])
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func getArticles() {
        ariticles.subscribe(onNext: { (date) in
            Service().getLatestAriticles(date: date) { [weak self] (response) in
                if let data = response {
                    self?.getAriticle.accept(data.response.docs)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func searchArticles() {
        ariticlesSearch.asObservable().subscribe(onNext: { [weak self] (param) in
            if param.count <= 0 || param.isEmpty {return}
            Service().searchAriticles(text: param) { (response) in
                if let data = response {
                    self?.getAriticlesSearch.accept(data.response.docs)
                }
            }
        }).disposed(by: disposeBag)
    }
}

