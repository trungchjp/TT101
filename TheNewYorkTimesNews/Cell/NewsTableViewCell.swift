//
//  NewsTableViewCell.swift
//  TheNewYorkTimesNews
//
//  Created by Nguyễn Trung on 12/19/19.
//  Copyright © 2019 Nguyễn Trung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var articlesImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(docs: Document) {
        titleLabel.text = docs.headline.main
        publishedDateLabel.text = convertDateToString(date: docs.pubDate)
        subtitleLabel.text = docs.snippet
        
        if docs.multimedia.count > 0 {
            var urlString = docs.multimedia[0].url
            urlString = "https://www.nytimes.com/\(urlString)"
            articlesImageView.setImage(urlString)
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
    
}

extension UIImageView {
    func setImage(_ urlString: String) {
        if let url = URL(string: urlString){
            kf.indicatorType = .activity
            kf.setImage(with: url)
        }
    }
}
