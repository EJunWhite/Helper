//
//  GalleryDetailViewController.swift
//  Helper
//
//  Created by EJun on 2018. 5. 21..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import UIKit

protocol OnTapCallBack {
    func onetap(isTap: Bool)
}

class GalleryDetailViewController: SuperViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var myCollectionView: UICollectionView!
    var imgPathArray = [String]()
    var passedContentOffset = IndexPath()
    var currentIndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isToolbarHidden = true
        
        self.view.backgroundColor = UIColor.red
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.isPagingEnabled = true
        myCollectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        let row = CGFloat(passedContentOffset.row)
        
        let pageSize = self.view.bounds.size
        let contentOffset = CGPoint(x: (pageSize.width * row), y: 0)
        self.myCollectionView.setContentOffset(contentOffset, animated: false)
        
        self.view.addSubview(myCollectionView)
        
        getCoordinateView("최초", myCollectionView, false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgPathArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        cell.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        
        let image = UIImage(contentsOfFile: imgPathArray[indexPath.row])!
        
        cell.imgView.image = image
        cell.ontap = self
        
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((cell.imgView.image)!, 1)!)
        var imageSize: Int = imgData.length
        log.info("index : \(indexPath.row) section :\(indexPath.section) width : \(image.size.width) height : \(image.size.height) size of image in KB: \(imageSize / 1024) ")
        
        UIGraphicsBeginImageContextWithOptions(cell.imgView.frame.size, true, 1.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = myCollectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
        
        getCoordinateView("두번째 ", myCollectionView, false)
    }

    func getCoordinateView(_ msg:String, _ collectionView: UICollectionView, _ isBool: Bool) {
        if isBool {
            log.info("STATUS BAR HIDE ==============================================================================================")
        } else {
            log.info("STATUS BAR SHOW==============================================================================================")
        }
        log.info("[START][contentOffset] ->")
        log.info("\(msg)  collectionView.contentOffset.x ::::: \(collectionView.contentOffset.x)")
        log.info("\(msg)  collectionView.contentOffset.Y ::::: \(collectionView.contentOffset.y)")
        log.info("[START][contentSize] ->")
        log.info("\(msg)  collectionView.contentSize.width ::::: \(collectionView.contentSize.width)")
        log.info("\(msg)  collectionView.contentSize.height ::::: \(collectionView.contentSize.height)")
        if #available(iOS 11.0, *) {
            log.info("[START][adjustedContentInset] ->")
            log.info("\(msg)  collectionView.adjustedContentInset.top ::::: \(collectionView.adjustedContentInset.top)")
            log.info("\(msg)  collectionView.adjustedContentInset.left ::::: \(collectionView.adjustedContentInset.left)")
            log.info("\(msg)  collectionView.adjustedContentInset.bottom ::::: \(collectionView.adjustedContentInset.bottom)")
            log.info("\(msg)  collectionView.adjustedContentInset.right ::::: \(collectionView.adjustedContentInset.right)")
        }
    }
}

extension GalleryDetailViewController: OnTapCallBack {
    func onetap(isTap: Bool) {
        UIApplication.shared.setStatusBarHidden(isTap, with: UIStatusBarAnimation.none)
        self.navigationController?.isNavigationBarHidden = isTap
        
        let row = CGFloat(currentIndexPath.row)
        let pageSize = self.view.bounds.size
        var contentOffset = CGPoint(x: (pageSize.width * row), y: 0)
    
        self.myCollectionView.setContentOffset(contentOffset, animated: false)
        self.myCollectionView.reloadData()
    }
}

class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    var scrollImg: UIScrollView!
    var imgView: UIImageView!
    var ontap:OnTapCallBack!
    var isTap:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0

        let oneTapGest = UITapGestureRecognizer(target: self, action: #selector(handleOndTapScrollView(recognizer:)))
        oneTapGest.numberOfTapsRequired = 1

        scrollImg.addGestureRecognizer(oneTapGest)
        
        self.addSubview(scrollImg)
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "user3")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
    }
    
    @objc func handleOndTapScrollView(recognizer: UITapGestureRecognizer) {
        isTap = !isTap
        
        ontap.onetap(isTap: isTap)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        scrollImg.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
