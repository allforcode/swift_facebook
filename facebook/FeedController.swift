//
//  ViewController.swift
//  facebook
//
//  Created by Paul Dong on 28/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit


class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var posts = Posts()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "all_posts", ofType: "json"){
            do {
                let data  = try (NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)) as Data
                
                let jsonDictionary = try (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String: [[String: AnyObject]]]

                self.posts.setValuesForKeys(jsonDictionary)
            } catch let err {
                print(err)
            }
        }
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let diskPath = "myDiskPath"
        
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
        URLCache.shared = urlCache
        
        navigationItem.title = "Facebook Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        cell.post = posts[indexPath]
        cell.feedController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //dynamic height based on content
        if let text = posts[indexPath].statusText {
            let dummySize = CGSize(width: view.frame.width - 16, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = NSString(string: text).boundingRect(with: dummySize, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 1 + 44
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 16)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
    //when device rotating
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let blackBackgroundView = UIView()
    let zoomImageView = UIImageView()
    
    var statusImageView: UIImageView?
    
    public func animateImageView(imageView: UIImageView){
        statusImageView = imageView
        if let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) {
            imageView.alpha = 0
            if let keyWindow = UIApplication.shared.keyWindow {
                blackBackgroundView.frame = keyWindow.frame
                blackBackgroundView.backgroundColor = UIColor.black
                blackBackgroundView.alpha = 0
                keyWindow.addSubview(blackBackgroundView)
                print("window: \(keyWindow.frame.height), view: \(view.frame.height)")
                zoomImageView.frame = startingFrame
                zoomImageView.isUserInteractionEnabled = true
                zoomImageView.image = imageView.image
                zoomImageView.contentMode = .scaleAspectFill
                zoomImageView.clipsToBounds = true
                keyWindow.addSubview(zoomImageView)
                
                zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                
                UIView.animate(withDuration: 0.75, animations: {
                    let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                    let y = (self.view.frame.height - startingFrame.height) / 2
                    self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                    self.blackBackgroundView.alpha = 1
                })
            }

        }
    }
    
    func zoomOut(){
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            UIView.animate(withDuration: 0.75, animations: {
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
            }, completion: { (_) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            })
        }
    }
}

