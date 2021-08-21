//
//  SearchCell.swift
//  Nudge
//
//  Created by Dcube Ventures on 30/09/19.
//  Copyright © 2019 Dcube Ventures. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var myOffers:[MyOffersData] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        searchCollectionView!.collectionViewLayout = layout
        collectionViewHeight.constant = 1
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
extension SearchCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myOffers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell
        
        cell?.productNameLbl.text = myOffers[indexPath.row].productdetails?.first?.name ?? ""
        let productImageURl = URL(string: (myOffers[indexPath.row].productdetails?.first!.image)!)
        let clientImageURl = URL(string: (myOffers[indexPath.row].clientdetails?.first!.image)!)
        cell?.productImgView!.sd_setImage(with: productImageURl , placeholderImage: nil)
        cell?.clientImgView.sd_setImage(with: clientImageURl , placeholderImage: nil)
        let height = searchCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.layoutIfNeeded()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 2) - 12
        
        return CGSize(width: scaleFactor, height: scaleFactor - 20)
    
    }
}
