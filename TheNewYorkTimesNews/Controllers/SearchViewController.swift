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

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: AriticleViewModel!
    var docs: Document!
    let disposeBag = DisposeBag()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTextFeild()
        selectRow()
        
        viewModel = AriticleViewModel()
        viewModel.searchArticles()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    
    }
    
    func initTextFeild() {
        searchTextField.becomeFirstResponder()
        searchTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe(onNext: { (_) in
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
            }).disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent([.editingDidEndOnExit]).asObservable().subscribe(onNext: { (_) in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    @objc func getData() {
        let text = searchTextField.text?.trimmingCharacters(in: .whitespaces)
        guard let keyword = text, !keyword.isEmpty else { return }
        Observable.of(keyword).bind(to: viewModel.ariticlesSearch).disposed(by: self.disposeBag)
        
        viewModel.getAriticlesSearch.asObservable().bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { index, entity, cell in
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
