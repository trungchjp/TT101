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
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var viewModel: AriticleViewModel?
    var docs: Document?
    var date: Date = Date()
    let disposeBag = DisposeBag()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        viewModel = AriticleViewModel()
        viewModel?.getArticles()
        datePicker.addTarget(self, action: #selector(changeDate(id:)), for: .valueChanged)
        getData()
        selectRow()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib.init(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
         
        navigationItem.title = "NewYorkTimes"
//        navigationController?.navigationBar.barTintColor = UIColor.gray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func refresh(sender: AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func changeDate(id: UIDatePicker) {
        self.date = id.date
        Observable.of(date).bind(to: viewModel!.ariticles).disposed(by: disposeBag)
    }

    @objc func search() {
        let mainVC = SearchViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func getData() {
        let dataSource = RxTableViewSectionedReloadDataSource<CustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            cell.bindData(docs: item)
            return cell
        })

        Observable.of(date).bind(to: viewModel!.ariticles).disposed(by: disposeBag)
        viewModel?.getAriticle.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
//    func getData() {
//        Observable.of(date).bind(to: viewModel!.ariticles).disposed(by: disposeBag)
//        viewModel?.getAriticle.asObservable().bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { index, entity, cell in
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

struct CustomData {
    var items: [Item]
}

extension CustomData: SectionModelType {
    typealias Item = Document
    
    init(original: CustomData, items: [Document]) {
        self = original
        self.items = items
    }
}
