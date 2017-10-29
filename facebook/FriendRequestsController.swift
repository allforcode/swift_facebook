//
//  FriendRequestsController.swift
//  facebook
//
//  Created by Paul Dong on 29/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class FriendRequestController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let requestCellId = "requestCellId"
    let headerId = "headerId"
    
    var requests = Requests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "friends", ofType: "json"){
            do {
                let data  = try (NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)) as Data
                
                let jsonDictionary = try (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String: [[String: String]]]
                
                self.requests.setValuesForKeys(jsonDictionary)
            } catch let err {
                print(err)
            }
        }
        
        collectionView?.register(RequestCell.self, forCellWithReuseIdentifier: requestCellId)
        
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.requests.requestedFriend.count : self.requests.suggestedFriend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requestCellId, for: indexPath) as! RequestCell
        
        if indexPath.section == 0 {
            cell.friend = self.requests.requestedFriend[indexPath.item]
        } else {
            cell.friend = self.requests.suggestedFriend[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
            
            if indexPath.section == 0 {
                cell.sectionTitleLabel.text = "friend requests".uppercased()
            }
            return cell
        }

        return UICollectionViewCell()
    }
}
