//
//  SearchViewController.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: AriticleViewModel!
    var docs: Document!
    let disposeBag = DisposeBag()
    var timer: Timer?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        checkText()
        selectRow()
        
        searchTextField.placeholder = "Search for Articles"
        
        viewModel = AriticleViewModel()
        viewModel.searchArticles()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
//        getData()
//        Observable.of("key").bind(to: viewModel.ariticlesSearch).disposed(by: disposeBag)
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    
    }
    
    @objc func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func checkText() {
        searchTextField.rx.controlEvent([.editingChanged])
            .throttle(.microseconds(1000), scheduler: MainScheduler.instance)
            .asObservable().subscribe(onNext: { [weak self] (_) in
                self?.getData()
            }).disposed(by: disposeBag)
    }
    
    func getData() {
        let dataSource = RxTableViewSectionedReloadDataSource<CustomData>( configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            cell.bindData(docs: item)
            return cell
        })
        let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let key = text, !key.isEmpty else { return }
        Observable.of(key).bind(to: self.viewModel.ariticlesSearch).disposed(by: self.disposeBag)
        tableView.dataSource = nil
        viewModel.getAriticlesSearch.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
//    @objc func getData() {
//        let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard let keyword = text, !keyword.isEmpty else { return }
//        Observable.of(keyword).bind(to: viewModel.ariticlesSearch).disposed(by: self.disposeBag)
//        tableView.dataSource = nil
//        viewModel.getAriticlesSearch.asObservable().bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { index, entity, cell in
//            cell.bindData(docs: entity)
//        }.disposed(by: disposeBag)
//    }

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


