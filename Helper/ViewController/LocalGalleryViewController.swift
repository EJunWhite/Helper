//
//  GalleryViewController.swift
//  Helper
//
//  Created by Jun on 2018. 5. 16..
//  Copyright © 2018년 EJun. All rights reserved.
//
import Foundation
import UIKit
import Photos
import CoreGraphics


class LocalGalleryViewController: SuperViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var trashBtnItem: UIBarButtonItem!
    
    var imageList:[UIImage] = [UIImage]()
    var imagePathList:[String] = [String]()
    var pickerController = UIImagePickerController()
    var isSelect:Bool = false
    var deleteList:[IndexPath] = []

    // MARK: - 이미지 추가
    @IBAction func addPicture(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumAction = UIAlertAction(title: "앨범", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            log.info("앨범")
            /// Photo view 열기
            func goToPhotoController() {
                self.pickerController.sourceType = .photoLibrary
                self.pickerController.isNavigationBarHidden = true
                self.pickerController.isToolbarHidden = true
                
                self.present(self.pickerController, animated: true, completion: nil)
                
                self.pickerController.delegate = self                
            }
            
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            
            switch photoStatus {
                case .authorized:
                    goToPhotoController()
                    break
                case .denied, .restricted:
                    //Camera not available - Alert
                    let internetUnavailableAlertController = UIAlertController (title: nil, message: "사진을 등록하려면 '사진' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "설정", style: .default) { (_) -> Void in
                        let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
                        if let url = settingsUrl {
                            DispatchQueue.main.async {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url as URL)
                                } //(url as URL)
                            }
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
                    internetUnavailableAlertController .addAction(cancelAction)
                    internetUnavailableAlertController .addAction(settingsAction)
                    self.present(internetUnavailableAlertController , animated: true, completion: nil)
                    break
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) in
                        if status == PHAuthorizationStatus.authorized {
                            goToPhotoController()
                        } else {
                        }
                    })
                    break
            }
        })
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            /// 카메라 open
            func goToCameraController() {
                /* For take picture*/
                self.pickerController.sourceType = .camera
                self.pickerController.showsCameraControls = true
                
                self.present(self.pickerController, animated: true, completion: nil)
                
                self.pickerController.delegate = self
            }
            
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch cameraStatus {
            case .authorized:
                goToCameraController()
                break
            case .denied,.restricted:
                //Camera not available - Alert
                let internetUnavailableAlertController = UIAlertController (title: nil, message: "사진을 등록하려면 '비디오' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "설정", style: .default) { (_) -> Void in
                    let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url as URL)
                            // Fallback on earlier versions
                        } //(url as URL)
                    }
                }
                let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
                internetUnavailableAlertController .addAction(cancelAction)
                internetUnavailableAlertController .addAction(settingsAction)
                self.present(internetUnavailableAlertController , animated: true, completion: nil)
                
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                    if granted {
                        goToCameraController()
                    }
                })
                break
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            log.info("Cancelled")
        })
        
        // 4
        optionMenu.addAction(albumAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.getImageInDocument()
        
//        collectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadImagesFromAlbum(folderName:String) -> [String]{
        log.info("folderName :::: \(folderName)")
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        var theItems = [String]()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(folderName)
            
            do {
                theItems = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
                return theItems
            } catch let error as NSError {
                print(error.localizedDescription)
                return theItems
            }
        }
        return theItems
    }
    
    func getImageInDocument() {
        if imageList.count > 0 {
            imageList.removeAll()
        }
        
        if imagePathList.count > 0 {
            imagePathList.removeAll()
        }
        
        imagePathList = [String]()
        imageList = [UIImage]()
        
        let fileManager = FileManager.default
//        // Library Directory
//        var urls_l = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
//        // Application Support Directory
//        var urls_a = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
//        // Caches Directory
//        var urls_c = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
//        // Temporary Directory
//        let tempUrl = FileManager.default.temporaryDirectory
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        self.showIndicator()
        
        DispatchQueue.global(qos: .background).async {
            
            // Document Directory
            var urls_d = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            
            if let documentUrl = urls_d.first {
                do {
                    let url = documentUrl.absoluteString.replace(delim: "file:///", withString: "")
                    var documents = try fileManager.contentsOfDirectory(atPath: documentUrl.absoluteString.replace(delim: "file:///", withString: ""))
                    let path = documentUrl.absoluteString.replace(delim: "file:///", withString: "")
                    
                    // Sorting
                    documents = documents.sorted(by: {(index0: String, index1: String) -> Bool in
                        let a:Int? = Int(index0)
                        let b:Int? = Int(index1)

                        return a! < b!
                    })
                    
                    for item in documents {
                        if fileManager.fileExists(atPath: path + item) {
                            let image = UIImage(contentsOfFile: path + item)!

                            self.imagePathList.append(path + item)
                            self.imageList.append(self.resizeImage(image: image, targetSize: CGSize(width: image.size.width / 5, height: image.size.height / 5)))
                        }
                    }
                    
                    if self.imageList.count > 0  {
                        DispatchQueue.main.async {
                            self.hideIndicator()
                            print("This is run on the main queue, after the previous code in outer block")
                            self.collectionView.reloadData()
                        }
                    }
                    
//                    log.info("documents :: \(documents.count)")

                    // Sorting
//                    documents = documents.sorted(by: {(index0: String, index1: String) -> Bool in
//                        let a:Int? = Int(index0)
//                        let b:Int? = Int(index1)
//
//                        return a! < b!
//                    })
                    
//                    log.info("documentUrl : \(documentUrl)")
//                    for item in documents {
//                        let url = URL(string: documentUrl.absoluteString + item)
//                        PHPhotoLibrary.shared().performChanges({
//                            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url!)
//                            let assetForDoc: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [(assetRequest?.placeholderForCreatedAsset?.localIdentifier)!], options: nil)
//
//                            print(assetForDoc)
//                            print(assetForDoc.count)
//
//                        })
//                    }
                  
//
               
                    
//                    log.info("urls_d :::: \(urls_d.debugDescription)")
//                    var documents = try fileManager.contentsOfDirectory(atPath: documentUrl.absoluteString.replace(delim: "file:///", withString: ""))
//                    let path = documentUrl.absoluteString.replace(delim: "file:///", withString: "")
//
//                    // Sorting
//                    documents = documents.sorted(by: {(index0: String, index1: String) -> Bool in
//                        let a:Int? = Int(index0)
//                        let b:Int? = Int(index1)
//
//                        return a! < b!
//                    })
//
//                    for item in documents {
//                        if fileManager.fileExists(atPath: path + item) {
//                            let image = UIImage(contentsOfFile: path + item)!
//
//                            self.imagePathList.append(path + item)
//                            self.imageList.append(self.resizeImage(image: image, targetSize: CGSize(width: image.size.width / 5, height: image.size.height / 5)))
//                        }
//                    }
////
//                    if self.imageList.count > 0  {
//                        DispatchQueue.main.async {
//                            print("This is run on the main queue, after the previous code in outer block")
//                            self.collectionView.reloadData()
//                        }
//
//
//                    }
                    
                } catch {
                    
                }
            } // if
            
        }

    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Bottom bar
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        self.changeLeftBarButtonItemSelected()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func selectAction(_ sender: Any) {
        changeLeftBarButtonItemCancle()
    }
    
    // MARK: - 선택된 이미지 삭제
    /// 선택된 이미지 삭제
    @objc func actionTrashAboutPictures() {
        if self.deleteList.count > 0 {
            
            self.showIndicator()
            let fileManager = FileManager.default
            
            var urls_d = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if let documentUrl = urls_d.first {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    do {
                        let documents = try fileManager.contentsOfDirectory(atPath: documentUrl.absoluteString.replace(delim: "file:///", withString: ""))
                        let path = documentUrl.absoluteString.replace(delim: "file:///", withString: "")
                        var count = 0
                        for item in documents {
                            if self.deleteList.count > 0 {
                                for deleteItem in self.deleteList {
                                    
                                    if (count == deleteItem.row) {
                                        var cell = self.collectionView.cellForItem(at: deleteItem) as! GalleryCollectionViewCell
                                        cell.selectBtn.isSelected = false
                                        
                                        self.collectionView.cellForItem(at: deleteItem)?.isSelected = false
                                        
                                        self.collectionView.beginInteractiveMovementForItem(at: deleteItem)

                                        if fileManager.fileExists(atPath: path + item){
                                            try fileManager.removeItem(atPath: path + item)
                                        }
                                        break
                                    }
                                }
                            }
                            count += 1
                        }
                        
                        for deleteItem in self.deleteList {
                            log.info("################################################")
                            log.info("It is not sorting.....imageListCount :: \(self.imageList.count)  deleteItem ::: \(deleteItem.row)")
                            log.info("################################################")
                        }
                        
                        /** sorting **/
                        self.deleteList = self.deleteList.sorted(by: {(index0: IndexPath, index1: IndexPath) -> Bool in
                            return index0.row > index1.row
                        })

                        log.info("deleteList count :: \(self.deleteList.count)")
                        
                        //  마지막 처리
                        for deleteItem in self.deleteList {
                            log.info("################################################")
                            log.info("imageListCount :: \(self.imageList.count)  deleteItem ::: \(deleteItem.row)")
                            self.imageList.remove(at: deleteItem.row)
                            log.info("################################################")
                        }
                        self.deleteList.removeAll()

                        self.changeLeftBarButtonItemSelected()
                        
                        self.hideIndicator()
                        
                    } catch {
                        
                    }
                    
                })
                
            }
        }
    }
    
    //MARK: - 선택 버튼 클릭시
    @objc func changeLeftBarButtonItemCancle() {
        // Bottom bar
        var items = self.navigationController?.toolbar.items
        items![0] = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocalGalleryViewController.changeLeftBarButtonItemSelected))
        if (items?.count == 1) {
            items?.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil))
            items?.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(LocalGalleryViewController.actionTrashAboutPictures)))
        }
        self.navigationController?.toolbar.setItems(items, animated: true)
        
        isSelect = true
        collectionView.reloadData()
     }
    
    //MARK: - 취소 버튼 클릭시
    @objc func changeLeftBarButtonItemSelected() {
        // Bottom bar
        var items = self.navigationController?.toolbar.items
        items![0] = UIBarButtonItem(title: "선택", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocalGalleryViewController.changeLeftBarButtonItemCancle))
        log.info("count :: \(items?.count)")
        if (items?.count == 3) {
            items?.remove(at: 2)
            items?.remove(at: 1)
        }
        self.navigationController?.toolbar.setItems(items, animated: true)
        isSelect = false
        
//        for cell in self.collectionView.visibleCells {
//            let indexPath = self.collectionView.indexPath(for: cell)
//        }
        
        self.collectionView.reloadData()
//        self.collectionView.cellForItem(at: <#T##IndexPath#>).up
        self.deleteList.removeAll()
    }

    @IBAction func deletePictures(_ sender: Any) {
    }
}

protocol GalleryCollectionViewCallBack {
    func selectedCell(selected: Bool, index: IndexPath)
}


// MARK: - <#UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout#>
extension LocalGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.isHidden = true
//        log.info("end displaying index : \(cell.index.row) section :\(cell.index.section) index :\(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.imageView.image = imageList[indexPath.item]
        cell.index = indexPath
        cell.galleryCollectionViewCallBack = self
        
        if isSelect {
            cell.selectBtn.isHidden = false
            cell.selectBtn.isSelected = false
        } else {
            cell.selectBtn.isHidden = true
        }
        
        cell.isHidden = false
        
        return cell
    }
    
    // selectd
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelect {
        } else {
            let vc = GalleryDetailViewController()
            vc.imgPathArray = self.imagePathList
            
            vc.passedContentOffset = indexPath
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

// MARK: - <#GalleryCollectionViewCallBack#>
extension LocalGalleryViewController: GalleryCollectionViewCallBack {
    /// 이미지 리스트의 이미지들을 선택시 : 삭제한 이미지를 선택시
    ///
    /// - Parameters:
    ///   - selected: <#selected description#>
    ///   - index: <#index description#>
    func selectedCell(selected:Bool, index: IndexPath) {
        log.info("selected:: \(selected), index :: \(index.row), deleteList :: \(deleteList.count)")
        if selected {
            deleteList.append(index)
        } else {
            var count = -1
            for deleteIndex in deleteList {
                count += 1
                if index.row == deleteIndex.row {
                    break
                }
            }
            
            if count > -1 {
                deleteList.remove(at: count)
            }
        }
    }
}

// MARK: - <#UIImagePickerControllerDelegate & UINavigationControllerDelegate#>
extension LocalGalleryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    /// 이미지 선택 후 이미지 local에 저장 하는 method
    ///
    /// - Parameters:
    ///   - picker: <#picker description#>
    ///   - info: <#info description#>
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /// doing...
        func doProcess() {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute:{
//                self.collectionView.reloadData()
                if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    image = ImageUtil.imageOrientation(image)
                    log.info("width ::\(image.size.width)")
                    log.info("height ::\(image.size.height)")
                    
                    // Image Information
//                    let selectedIamgeSize: NSData = NSData(data: UIImageJPEGRepresentation(image, 1)!)
                    let selectedIamgeSize: NSData = NSData(data: UIImagePNGRepresentation(image)!)
                    let selectedImageSize:Int = selectedIamgeSize.length

                    let fileManager = FileManager.default
                    
                    log.info("selectedImageSize ::\(selectedImageSize)")

                    if let data = UIImagePNGRepresentation(image) {
                        let time = self.getTimeName()
//                        var filename = self.getDocumentsDirectory().appendingPathComponent("\(time).png")
                        var filename = self.getDocumentsDirectory().appendingPathComponent("\(time)")

                        log.info("filename ::\(filename)")
                        // Writing
                        try? data.write(to: filename)

                        let path = filename.absoluteString.replace(delim: "file:///", withString: "")
                        
                        let image = UIImage(contentsOfFile: path)!
                        
                        // Append imageList
                        self.imageList.append(self.resizeImage(image: image, targetSize: CGSize(width: image.size.width / 5, height: image.size.height / 5)))
                        
                        // total imageList count
                        let indexPath = IndexPath(
                            item: self.imageList.count - 1,
                            section: 0
                        )
                        
                        // add item at collectionView and move at bottom in scroll
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            self.collectionView?.performBatchUpdates({
                                self.hideIndicator()
                                
                                //add Item at collectionView
                                self.collectionView.insertItems(at: [indexPath])
                            }, completion: nil)
                            
                            // move scroll
                            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                        })
                        
                    }// data
                } // image
                
            }) // Dispatch
        }// doProcess
        
        picker.dismiss(animated: true, completion: {
            self.showIndicator()
            
            doProcess()
        })

    }
    
    /// 년월일시분초
    ///
    /// - Returns: <#return value description#>
    func getTimeName() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let result = dateFormatter.string(from: now as Date)

        return result
    }
    
    /// PickerController dismiss
    ///
    /// - Parameter picker: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
