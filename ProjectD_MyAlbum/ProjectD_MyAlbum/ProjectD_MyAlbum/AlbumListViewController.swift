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
    
    var dataArray: [PHAssetCollection] = []
    
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
    
    private var fetchResult: PHFetchResult<PHAsset>?
    private var fetchResultOfCollection: PHFetchResult<PHAssetCollection>?
    let fetchSortDescriptorKey: String = "modificationDate"
    let albumListTitle = "앨범"
    
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
    

    
    private func requestCollection() {
        let fetchOptions = PHFetchOptions()
        let assetCollection: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        let getAlbum: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        print(getAlbum)
        
        
        var albumAssetCollection: PHAssetCollection?
        
        
        for i in 0 ..< getAlbum.count {
            albumAssetCollection = getAlbum[i] as! PHAssetCollection
            print("🟢 : \(albumAssetCollection?.localizedTitle)")
            guard let fetchAlbumCollection: PHAssetCollection = albumAssetCollection else {
                return
            }
            
            
        }
        
     
        
        guard let assetCollectionFirstObject = getAlbum.firstObject else {
            return
        }

        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: fetchSortDescriptorKey, ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: assetCollectionFirstObject, options: fetchOptions)
//        self.fetchResultOfCollection = PHAssetCollection.fetchAssetCollectionsContaining(<#T##asset: PHAsset##PHAsset#>, with: <#T##PHAssetCollectionType#>, options: <#T##PHFetchOptions?#>)

        
        dataArray.append(assetCollectionFirstObject)

        print("🟡 : \(assetCollectionFirstObject.localizedTitle)")
    }
    
    private func authorizationStatusOfPhotoLibrary() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가")
            self.requestCollection()
            print("🔴 : \(dataArray)")
            print("🔵 : \(dataArray.count)")
            
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
//        return self.fetchResultOfCollection?.count ?? 0
        return self.fetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListCollectionViewCell.cellId, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        let assetOfCollection = fetchResultOfCollection?.object(at: indexPath.item)
       
        let asset: PHAsset = fetchResult?.object(at: indexPath.item) ?? PHAsset()
        
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
        
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: widthAndHeight, height: widthAndHeight),
                                  contentMode: .aspectFill,
                                  options: nil) {image, _ in
                                    cell.thumbnailImage = image
        }
        
        
        
        return cell
    }
    
    
    
}
