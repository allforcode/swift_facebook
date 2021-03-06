//
//  FeedCell.swift
//  facebook
//
//  Created by Paul Dong on 28/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    //urlsession has cached images
    //var imageCache = NSCache<NSString, UIImage>()
    
    var feedController: FeedController?
    
    func handleTab(_ sender: UITapGestureRecognizer){
        feedController?.animateImageView(imageView: statusImageView)
    }
    
    var post: Post? {
        didSet {
            if let name = post?.name{
                nameLabel.text = name
                let attributeText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
                
                if let city = post?.location?.city {
                    attributeText.append(NSAttributedString(string: "\nDecember 18 ・ \(city) ・ ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : UIColor.rgb(red: 155, green: 161, blue: 171)]))
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributeText.addAttributes([NSParagraphStyleAttributeName : paragraphStyle], range: NSMakeRange(0, attributeText.string.characters.count))
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributeText.append(NSAttributedString(attachment: attachment))
                
                nameLabel.attributedText = attributeText
            }
            
            if let imageName = post?.profileImageName{
                profileImageView.image = UIImage(named: imageName)
            }
            
            if let text = post?.statusText {
                statusTextView.text = text
            }
            
            if let likes = post?.numLikes, let comments = post?.numComments {
                likesCommentsLabel.text = "\(likes) Likes   \(comments) Comments"
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
                self.loader.stopAnimating()
            }else if let statusImageUrl = post?.statusImageUrl {
                URLSession.shared.dataTask(with: URL(string: statusImageUrl)!, completionHandler: { (data, response, error) in
                    
                    if let err = error {
                        print(err)
                    }
                    
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        self.statusImageView.image = image
                        self.loader.stopAnimating()
                    }
                }).resume()
            }
        }
    }
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        return l
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "zuckprofile")
        return iv
    }()

    let statusTextView: UITextView = {
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    let statusImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.image = UIImage(named: "zuckdog")
        return iv
    }()
    
    let likesCommentsLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return l
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return v
    }()
    
    let likeButton: UIButton = FeedCell.button(title: "Like", imageName: "like")
    
    let commentButton: UIButton = FeedCell.button(title: "Comment", imageName: "comment")
    
    let shareButton: UIButton = FeedCell.button(title: "Share", imageName: "share")
    
    static func button(title: String, imageName: String) -> UIButton {
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        b.setImage(UIImage(named: imageName), for: .normal)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return b
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(handleTab))
        statusImageView.addGestureRecognizer(tabGesture)
        
        setupStatusImageViewLoader()
        
        addConstraints(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraints(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraints(format: "H:|-4-[v0]-4-|", views: statusImageView)
        addConstraints(format: "H:|-12-[v0]-12-|", views: likesCommentsLabel)
        addConstraints(format: "H:|[v0]|", views: dividerLineView)
        
        //equally arranged horizontally
        addConstraints(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraints(format: "V:|-12-[v0]", views: nameLabel)
        addConstraints(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(1)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        
        addConstraints(format: "V:[v0(44)]|", views: commentButton)
        addConstraints(format: "V:[v0(44)]|", views: shareButton)
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        statusImageView.addSubview(loader)
        statusImageView.addConstraints(format: "H:|[v0]|", views: loader)
        statusImageView.addConstraints(format: "V:|[v0]|", views: loader)
    }
    
}

class RequestCell: BaseCell {
    
    var friend: Friend? {
        didSet {
            if let name = friend?.name {
                nameLabel.text = name
            }
            
            if let imageName = friend?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bill_gates_profile")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Bill Gates"
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    let confirmButton: UIButton = {
        return RequestCell.craatButton(title: "Confirm", titleColor: UIColor.white, backgroundColor: UIColor.rgb(red: 102, green: 153, blue: 255))
    }()
    
    let deleteButton: UIButton = {
        return RequestCell.craatButton(title: "Delete", titleColor: UIColor.gray, backgroundColor: UIColor.white)
    }()
    
    static func craatButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.backgroundColor = backgroundColor
        b.setTitleColor(titleColor, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.layer.cornerRadius = 2
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.layer.borderWidth = 1
        return b
    }
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return v
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.white
        
        addSubview(dividerLineView)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addConstraints(format: "H:|[v0]|", views: dividerLineView)
        addConstraints(format: "H:|-16-[v0(60)]-8-[v1]", views: profileImageView, nameLabel)
        addConstraints(format: "H:|-83-[v0(100)]-4-[v1(100)]", views: confirmButton, deleteButton)
        
        addConstraints(format: "V:|[v0(0.5)]-4.75-[v1(60)]-4.75-|", views: dividerLineView, profileImageView)
        addConstraints(format: "V:|-8-[v0]-8-[v1(28)]", views: nameLabel, confirmButton)
        addConstraints(format: "V:[v0]-8-[v1(28)]", views: nameLabel, deleteButton)
    }
}

class Header: BaseCell{
    let sectionTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "people you may know".uppercased()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        addSubview(sectionTitleLabel)
        addConstraints(format: "H:|-8-[v0]", views: sectionTitleLabel)
        addConstraint(NSLayoutConstraint(item: sectionTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
