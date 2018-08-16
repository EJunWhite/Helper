//
//  GalleryViewController.swift
//  Helper
//
//  Created by Jun on 2018. 5. 21..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CoreGraphics

class GalleryViewController: SuperViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageList:[UIImage] = [UIImage]()
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grabPhotos()
    }
    
    //MARK: grab photos
    func grabPhotos(){
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            
            // orderBy
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:200, height: 200),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageList.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        for fold in paths {
            print("fold ::\(fold)")
        }
        return paths[0]
    }
    
    /// PickerController dismiss
    ///
    /// - Parameter picker: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.imageView.image = imageList[indexPath.item]
        cell.imageView.contentMode = .scaleAspectFill
        cell.clipsToBounds = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.isHidden = true
    }
    
    // selectd
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        return CGSize(width: (width/4) - 1, height: (width/4) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}
