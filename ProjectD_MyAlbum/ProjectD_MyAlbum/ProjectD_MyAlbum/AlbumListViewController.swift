//
//  ViewController.swift
//  ProjectD_MyAlbum
//
//  Created by 김광준 on 2020/01/12.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {
    
    private var fetchResult: PHFetchResult<PHAsset>?
    private var thumbnailArray: [PHAsset] = []
    private var lastImage: PHAsset?
    private var fetchResultOfCollection: PHFetchResult<PHAssetCollection>?
    var tempStorageArray: [PHFetchResult<PHAsset>] = []
    
    
    
    // stackoverflow referance
    var assetCollection: PHAssetCollection?
    var asset: PHAsset?
    var albumFound: Bool?
    var photoAssets: PHFetchResult<PHAsset>?
    var photoAssetsArray: [PHFetchResult<PHAsset>] = []
    var countForCell: Int?
    var cellImage: [UIImage] = []
    var photo: UIImage?
    var assetCollectionCount: [PHAssetCollection] = []
    var assetCount: [PHAsset] = []
    var assetArray: [PHAsset] = []
    var photoArray: [UIImage] = []
    
    
//    var fetchReseult: PHFetchResult<PHAsset>!
    
    let fetchSortDescriptorKey: String = "creationDate"
    
    let albumListTitle = "앨범"
    
    var albumResult: PHAssetCollection?
    
    var albumsCount: Int?
    
    var images: UIImage?
    
    var imagesArray: [UIImage] = []
    
    var fetchCollection: PHFetchResult<PHAssetCollection>?
    
    private let albumListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        layout.sectionInset.top = 10
        layout.sectionInset.bottom = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AlbumListCollectionViewCell.self, forCellWithReuseIdentifier: AlbumListCollectionViewCell.cellId)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = albumListTitle
        self.albumListCollectionView.delegate = self
        self.albumListCollectionView.dataSource = self
        
        authorizationStatusOfPhotoLibrary()
        setupCollectionView()
        //        getPhotoLibraryData()
    }
    
    private func setupCollectionView() {
        view.addSubview(albumListCollectionView)
        albumListCollectionView.backgroundColor = .blue
        albumListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            albumListCollectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            albumListCollectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            albumListCollectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            albumListCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
    
    var fetchResultOfCollectionArray: [PHAssetCollection] = []
    var phAssetArray: [PHAsset] = []
    var fetchResultOfAssetArray: [PHFetchResult<PHAsset>] = []
    
    private func requestCollection() {
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let collection: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        print("🔴🔴 collection : \(collection)")
        
        let indexSetInit: IndexSet = IndexSet.init(integersIn: 0 ..< collection.count)
        
        if let firstObject: AnyObject = collection.objects(at: indexSetInit) as AnyObject {
            self.fetchResultOfCollection = collection
            print("😎😎 fetchResultOfCollection : \(fetchResultOfCollection)")
            
//            self.assetCollection = collection.firstObject as! PHAssetCollection
            self.albumFound = true
//            print("😎😎 firstObject : \(firstObject)")
        } else { self.albumFound = false }
        
        self.fetchResultOfCollection?.enumerateObjects({
            (object: AnyObject,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            if object is PHAssetCollection {
                self.assetCollection = object as! PHAssetCollection
                self.assetCollectionCount.append(self.assetCollection!)
                self.albumFound = true
                print("😎😎😎 assetCollection : \(self.assetCollection)")
                
                self.photoAssets = PHAsset.fetchAssets(in: self.assetCollection!, options: fetchOption)
                print("📸📸📸📸 Photo : \(self.photoAssets)")
                
                let assets: PHAsset = (self.photoAssets?.firstObject)!
                
                let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
                let targerSize = CGSize(width: widthAndHeight, height: widthAndHeight)
                
                imageManagerDefault.requestImage(for: assets, targetSize: targerSize, contentMode: .aspectFill, options: nil) { image, _ in
                    print("⚪️⚪️⚪️ \(image)")
                    self.cellImage.append(image!)
                }
                
                var temp = PHAsset.fetchAssets(in: self.assetCollection!, options: fetchOption)
                self.photoAssetsArray.append(temp)
                print("📸📸 photoAssetsArray : \(self.photoAssetsArray)")
                
                
                
                
                var asset = self.photoAssets?.firstObject
                print(asset)
                self.assetCount.append(asset!)
            
                
                
//                self.photoAssets = PHAsset.fetchAssets(in: collection, options: fetchOption)
//                print("📸📸📸📸 Photo : \(self.photoAssets)")
            } else { self.albumFound = false }
//            if let photoAsset = assetCollection
        })
//        print("📸📸 Photo : \(self.photoAssets)")
        
        
        
//        if let photoObject: AnyObject = assetCollection
        print("🔴🔴🔴 image count : \(self.cellImage.count)")
        print("🔴🔴🔴 asset count : \(self.assetCount.count)")
        print("🔴🔴🔴 asset Array : \(self.assetCount)")
        print("🔴🔴🔴 collection count : \(self.assetCollectionCount.count)")
//        if let firstObject: AnyObject = collection.firstObject {
//            self.assetCollection = collection.firstObject as! PHAssetCollection
//            self.albumFound = true
//            print("😎😎 firstObject : \(firstObject)")
//            print("😎😎😎 assetCollection : \(assetCollection)")
//        } else { self.albumFound = false }
//        print("😎collection : \(collection)")
//        var i = collection.count
//        self.photoAssets = PHAsset.fetchAssets(in: self.assetCollection!, options: nil)
//        print("😎😎😎😎 photoAssets : \(self.photoAssets)")
//        let imageManager = imageManagerDefault
//
//        self.photoAssets?.enumerateObjects({
//            (object: AnyObject!,
//            count: Int,
//            stop: UnsafeMutablePointer<ObjCBool>) in
//
//            if object is PHAsset {
//                let asset = object as! PHAsset
//                print("get PHAsset")
//
//                let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
//                let targerSize = CGSize(width: widthAndHeight, height: widthAndHeight)
//
//                imageManager.requestImage(for: asset,
//                                          targetSize: targerSize,
//                                          contentMode: .aspectFill,
//                                          options: nil) { (image, _) in
//                                            self.cellImage.append(image!)
//
//                                            print("📸📸📸📸 Photo : \(self.photo)")
//                                            self.photo = image
//                }
//            }
//        })
//        print("📸📸📸📸 Photo : \(self.photo)")
//        print("📸📸📸 Photo Count : \(self.cellImage.count)")
        
        
//        getAlbumData()
        
    }
    
    func getCellImage(cell: AlbumListCollectionViewCell, collectionView: UICollectionView, images: [UIImage]) {
        let cellIndexPath = collectionView.indexPath(for: cell)
//        print("🟠🟠🟠🟠🟠\(cellIndexPath?.item)")
        for i in 0 ..< images.count {
            if cellIndexPath?.item == i {
                cell.thumbnailImageView.image = images[i]
                print("🟠🟠🟠🟠🟠\(images[i])")
            }
        }
        
    }
    
    private func getAlbumData() {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let getAllAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        let indexSetInit = IndexSet.init(integersIn: 0 ..< getAllAlbums.count)
        
        fetchCollection = getAllAlbums
        
        let assetCollectionArray = getAllAlbums.objects(at: indexSetInit)
        countForCell = assetCollectionArray.count
        
        // stackoverflow referance 👇
        if let eachCollection: AnyObject = getAllAlbums.objects(at: indexSetInit) as AnyObject {
            self.assetCollection = eachCollection.firstObject as? PHAssetCollection
            self.albumFound = true
        } else { albumFound = false }
        var i = getAllAlbums.count
        self.photoAssets = PHAsset.fetchAssets(in: self.assetCollection ?? PHAssetCollection(), options: nil)

        self.photoAssets?.enumerateObjects({
            (object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in

            if object is PHAsset {
                let asset = object as! PHAsset
                print("get PHAsset object")

                let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
                let targerSize = CGSize(width: widthAndHeight, height: widthAndHeight)

//                imageManagerDefault.requestImage(for: asset,
//                                                 targetSize: targerSize,
//                                                 contentMode: .aspectFill,
//                                                 options: nil) { image, _ in
////                                                    print("😡 \(image)")
//                                                    self.cellImage.append(image!)
//                                                    print("😡😡\(self.cellImage.count)")
//                }
            }
        })
        
        // stackoverflow referance 👆
        
        print("🟢🟢 assetCollectionArray : \(assetCollectionArray), assetCollectionArray Count : \(assetCollectionArray.count), ")
        
//        let option = PHFetchOptions()
//        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var tempStorage: PHFetchResult<PHAsset>?
        
//        for i in 0 ..< assetCollectionArray.count {
//            tempStorage = PHAsset.fetchAssets(in: assetCollectionArray[i], options: option)
//            print("🔴🔴🔴 tempStorage : \(tempStorage)")
//            
//            if let fetchaAssets = tempStorage {
//                
//                self.tempStorageArray.append(fetchaAssets)
//                
//                lastImage = fetchaAssets.lastObject
//                let test = fetchaAssets.contains(lastImage!.self)
//                print("🟢🟢 lastImage : \(lastImage)")
//                
//                guard let thumbnails = lastImage else {
//                    return
//                }
//                
//                thumbnailArray.append(thumbnails)
//                
//            }
//            
//        }
        print("🟢 thumbnailArray.count : \(thumbnailArray.count)")
        print("🟢 tempStorageArray.count : \(tempStorageArray.count)")

        
        print("🟢🟢🟢 fetchResult : \(fetchResult)")
//        print("🟢🟢🟢 fetchResult : \(fetchResult)")
    
        let test = getAllAlbums.object(at: 1)
        let test2 = getAllAlbums.object(at: 2)
        let test3 = getAllAlbums.objects(at: indexSetInit)
        


        
        albumsCount = test3.count

        var getPhotoCountOfAllAlbums: PHFetchResult<PHAsset>?
        
        // 각 앨범 별 이름 배열
        var eachAlbumsTitles: [String] = []
        
        // PHAssetCollection 배열
        var getAllAlbumsArray: [PHAssetCollection] = []
        
        // 각 앨범 별 사진 갯수 배열
        var getAllPhotosCount: [Int] = []
        
        var eachAlbum: PHAssetCollection?
        
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
        
        for i in 0 ..< getAllAlbums.count {
            // 각각의 앨범
            eachAlbum = getAllAlbums[i]
            
            guard let eachAlbums = eachAlbum else {
                return
            }
            
            // 각각의 앨범 명 저장
            eachAlbumsTitles.append(eachAlbums.localizedTitle!)
            // 각각의 앨범 안에 있는 사진 수를 가져오기 위해 배열에 저장
            getAllAlbumsArray.append(eachAlbums)
            // 각각의 앨범 안에 있는 사진 수를 알아오기 위해 PHAsset.fetchAssets를 사용, 배열에 저장해 둔 각각의 앨범 PHAssetCollection 사용
            getPhotoCountOfAllAlbums = PHAsset.fetchAssets(in: eachAlbums, options: nil)
            // 각각의 앨범의 사진 수 배열에 저장
            if let photoCount = getPhotoCountOfAllAlbums {
                getAllPhotosCount.append(photoCount.count)
            }
        }
        print("🔴 getAllPhotosCount : \(getAllPhotosCount[0])")
        print("🔴 getAllPhotosCount : \(getAllPhotosCount[1])")
        print("🔴 getAllPhotosCount : \(getAllPhotosCount[2])")
        
    }
    

    
    private func authorizationStatusOfPhotoLibrary() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가")
            self.requestCollection()
            self.albumListCollectionView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    print("접근 허가")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.albumListCollectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 접근 불허함")
                default: break
                }
            }
        case .restricted:
            print("접근 제한")
        @unknown default:
            fatalError()
        }
    }
}

extension AlbumListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
        
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("🟡\(self.thumbnailArray.count)")
//        return self.tempStorageArray.count ?? 0
        return cellImage.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListCollectionViewCell.cellId, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        getCellImage(cell: cell, collectionView: collectionView, images: cellImage)
//        print("🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡")

        return cell
    }

}


