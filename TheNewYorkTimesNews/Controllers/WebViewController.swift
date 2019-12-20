//
//  WebViewController.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import UIKit
import RxWebKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.bounds)
        view.addSubview(webView)
        
        let request = URLRequest.init(url: url)
        webView.load(request)
    }

}
