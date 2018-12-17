//
//  NewsTableViewCell.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/3/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newImageView: UIImageView!
    
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    
    var news: News?{
        didSet{
            self.updateUI()
        }
    }
    
    var expandedArticle: ExpandedNews?{
        didSet{
            self.updateUI()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setUpButtonsConstraints()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func updateUI(){
        let imageUrl = URL(string: news?.imageUrl ?? "")
        self.newImageView.kf.setImage(with: imageUrl, completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image == nil || error != nil){
                print("error getting image")
            }
            else{
                DispatchQueue.main.async {
                    print("downloaded image from url: \(self.news?.imageUrl)")

                }
                
            }
            
        })
        
        newsHeadlineLabel?.text = news?.headline
        newsDescriptionLabel?.text = news?.description
        
        
        
    }
    
    func setUpButtonsConstraints(){
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newsHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints for image
        newImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        newImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        newImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 64).isActive = true
        newImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: 64).isActive = true
        
        //for title
        newsHeadlineLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        newsHeadlineLabel.leadingAnchor.constraint(equalTo: newImageView.trailingAnchor, constant: 8).isActive = true
        newsHeadlineLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8).isActive = true
        
        // for description
        newsDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: -8).isActive = true
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newImageView.trailingAnchor, constant: 8).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsHeadlineLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    @objc func imageViewTapped(sender: UITapGestureRecognizer) {
        
        guard let imageView = sender.view as? UIImageView
            else { return }
        if let urlString = self.news?.webUrl{
            guard let url = URL(string: urlString) else { return }
                UIApplication.shared.open(url)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(sender: )))
        newImageView.addGestureRecognizer(tap)
    }
}

