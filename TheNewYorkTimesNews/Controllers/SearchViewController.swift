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
    
    }
    
}
