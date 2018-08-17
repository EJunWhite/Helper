//
//  GalleryCollectionViewCell.swift
//  Helper
//
//  Created by Jun on 2018. 5. 18..
//  Copyright © 2018년 EJun. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clieckImgBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
   
    var index: IndexPath!
    var galleryCollectionViewCallBack: GalleryCollectionViewCallBack!
    
    @IBAction func selectedBtn(_ sender: Any) {
        selectBtn.isSelected = !selectBtn.isSelected
        
        galleryCollectionViewCallBack.selectedCell(selected: selectBtn.isSelected, index: index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
    
    
}

