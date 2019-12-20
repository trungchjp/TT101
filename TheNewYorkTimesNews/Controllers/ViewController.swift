//
//  ViewController.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: AriticleViewModel!
    var docs: Document!
    var date: Date = Date()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AriticleViewModel()
        viewModel.getArticles()
        getData()
        selectRow()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib.init(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
        navigationItem.title = "NewYorkTimes"
//        navigationController?.navigationBar.barTintColor = UIColor.gray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }

    @objc func search() {
        let mainVC = SearchViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func getData() {
        Observable.of(date).bind(to: viewModel.ariticles).disposed(by: disposeBag)
        viewModel.getAriticle.asObservable().bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { index, entity, cell in
            cell.bindData(docs: entity)
        }.disposed(by: disposeBag)
    }
    
    func selectRow() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Document.self))
        .bind { [unowned self] indexPath, model in
            let mainVC = WebViewController()
            if let url = URL.init(string: model.webUrl) {
                mainVC.url = url
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }.disposed(by: disposeBag)
    }

}

