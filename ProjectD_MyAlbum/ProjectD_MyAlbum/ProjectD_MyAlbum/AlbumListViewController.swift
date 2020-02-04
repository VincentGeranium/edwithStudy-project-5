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
    private var fetchResultOfCollection: PHFetchResult<PHAssetCollection>?
    
//    var fetchReseult: PHFetchResult<PHAsset>!
    
    let fetchSortDescriptorKey: String = "creationDate"
    
    let albumListTitle = "앨범"
    
    var albumResult: PHAssetCollection?
    
    var albumsCount: Int?
    
    var images: UIImage?
    
    var imagesArray: [UIImage] = []
    
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
        
        
        getAlbumData()
        
    }
    
    private func getAlbumData() {
        let option = PHFetchOptions()
        let getAllAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: option)
        
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let manager = PHImageManager.default()
    
        let getIndexSet = IndexSet.init(integersIn: 0 ..< getAllAlbums.count)
        
        print("🟢\(getIndexSet)")
        
        let test = getAllAlbums.object(at: 1)
        let test2 = getAllAlbums.object(at: 2)
        let test3 = getAllAlbums.objects(at: getIndexSet)

        print("🔵\(test)")
        print("🔵🔵\(test2)")
        print("🔵🔵🔵\(test3)")
        
        albumsCount = test3.count
        
        for i in 0 ..< test3.count {
            let asset = PHAsset.fetchAssets(in: test3[i], options: option)
            print("🟡 \(i)")
            print("🟡🟡 \(asset.count)")
            print("🟡🟡🟡 \(asset)")
            if asset.count > 0 {
                self.fetchResult = asset
            }
//            self.fetchResult = asset
        }
        
        
        
//        self.fetchResult = PHAsset.fetchAssets(in: test, options: option)
        guard let getLastImage = getAllAlbums.firstObject else {
            return
        }
//
        let assetFetchResult = PHAsset.fetchAssets(in: getLastImage, options: option)
//        self.fetchReseult = assetFetchResult
        print(fetchResult?.count)
        print(assetFetchResult.count)
        print("🔴\(assetFetchResult)")
        
        
        
        var getPhotoCountOfAllAlbums: PHFetchResult<PHAsset>?
        
        // 각 앨범 별 이름 배열
        var eachAlbumsTitles: [String] = []
        
        // PHAssetCollection 배열
        var getAllAlbumsArray: [PHAssetCollection] = []
        
        // 각 앨범 별 사진 갯수 배열
        var getAllPhotosCount: [Int] = []
        
        var eachAlbum: PHAssetCollection?
        
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
            
        let targerSize = CGSize(width: widthAndHeight, height: widthAndHeight)
        
        for i in 0 ..< getAllAlbums.count {
            // 각각의 앨범
            eachAlbum = getAllAlbums[i]
            
            guard let eachAlbums = eachAlbum else {
                return
            }
            
//            albumResult = getAllAlbumsArray[i]
            
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
            
//            getThumbnail(albumResult: eachAlbums, targetSize: targerSize)
//            print(eachAlbums)
//            print("♥️♥️♥️\(images)")
//            print("♥️♥️♥️\(imagesArray[i])")
        }
//        print("♥️♥️♥️\(imagesArray.count)")
//        print("♥️♥️♥️\(imagesArray[0])")
//        print("♥️♥️♥️\(imagesArray[1])")
//        print("♥️♥️♥️\(imagesArray[2])")
//        print("------------------------------------------------------------------------------------")
//        print(eachAlbumsTitles.count)
//
//        print("♥️♥️\(eachAlbumsTitles[0])")
//        print("♥️♥️\(eachAlbumsTitles[1])")
//        print("♥️♥️\(eachAlbumsTitles[2])")
//        print("♥️♥️\(eachAlbumsTitles[3])")
//
//        print("♥️\(getAllPhotosCount.count)")
//        print("♥️\(getAllPhotosCount[0])")
//        print("♥️\(getAllPhotosCount[1])")
//        print("♥️\(getAllPhotosCount[2])")
//        print("♥️\(getAllPhotosCount[3])")
        
//        print("♥️♥️♥️\(images)")
//        print("♥️♥️♥️\(getAllPhotosCount[3])")
        
        // 셀 갯수 생성을 위한 모든 앨범의 이름 갯수를 넣어줌
//        albumsCount = eachAlbumsTitles.count
        
        
        
    }
    
    private func getThumbnail(albumResult: PHAssetCollection, targetSize: CGSize) {
        //        DispatchQueue.async(execute: .global(qos: DispatchQoS.background))
        //        DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0).async(execute: <#() -> Void#>)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let fetchOption = PHFetchOptions()
            fetchOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            let manager = PHImageManager.default()
            
            let assetFetchResult = PHAsset.fetchAssets(in: albumResult, options: fetchOption)
            
            if assetFetchResult.count > 0 {
                if let imageAsset = assetFetchResult.lastObject as? PHAsset {
                    let requestOption = PHImageRequestOptions()
                    requestOption.isSynchronous = false
                    requestOption.deliveryMode = .highQualityFormat
                    manager.requestImage(for: imageAsset,
                                         targetSize: targetSize,
                                         contentMode: .aspectFill,
                                         options: nil) { image, _ in
                                            self.images = image
                                            self.imagesArray.append(image!)
                    }
                }
            }
        }
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

        return self.albumsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListCollectionViewCell.cellId, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
        
        let targerSize = CGSize(width: widthAndHeight, height: widthAndHeight)
        
        var cellThumbnail: UIImage?
        
//        for i in 0 ..< imagesArray.count {
//            cell.thumbnailImage = imagesArray[i]
//            print("🟡🟡🟡 \(imagesArray[i])")
//            print("🟡🟡🟡 \(imagesArray.count)")
//        }
        let imageManager = PHCachingImageManager()
        
        if let getAsset = fetchResult {
            
            let asset: PHAsset = getAsset.object(at: indexPath.item)
            
            print("🟠🟠🟠 \(getAsset)")
            
            imageManager.requestImage(for: asset,
                                        targetSize: CGSize(width: 30, height: 30),
                                        contentMode: .aspectFill,
                                        options: nil,
                                        resultHandler: { image, _ in
                                          cell.thumbnailImage = image
              })
        }
        
        
        
  
 
//        getThumbnail(albumResult: albumResult, targetSize: targerSize, cell: cell)
        
//        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
//
//        var asset: PHAsset?
//
//        for i in 0 ..< fetchResultOfAssetArray.count {
//
//            asset = fetchResultOfAssetArray[i].object(at: indexPath.item)
//
//
//        }
//
//
//            cachingImageManager.requestImage(for: asset!,
//                                      targetSize: CGSize(width: widthAndHeight, height: widthAndHeight),
//                                      contentMode: .aspectFill,
//                                      options: nil) { image, _ in
//                                        cell.thumbnailImage  = image
//            }
//
//
//        print("🔵 \(phAssetArray[0])")
//        print("🔵 \(phAssetArray[1])")
//        print(phAssetArray.count)
//
        

        return cell
    }
    

    
    
}
