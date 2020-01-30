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

    var albumAssetCollectionArray: [PHAssetCollection] = []
    
    var albumAssetID: [String] = []
    
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
    private var thumbnailAsset: PHAsset?
    private var fetchResultOfCollection: PHFetchResult<PHAssetCollection>?
    private var assetFetchResultss: PHFetchResult<AnyObject>?
    
    let fetchSortDescriptorKey: String = "creationDate"
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
    

    var fetchResultArray: [PHFetchResult<PHAssetCollection>?] = []
    var id: [String] = []
    var id2: [String] = []
    var assetCollectionArray: [PHAssetCollection] = []
    var albumTitles: [String] = []
    var albumConunt: [Int] = []
    var albumFirstObjects: [PHAsset] = []

    
    private func requestCollection() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let getMyAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
 
        getMyAlbums.enumerateObjects { (collection, index, stop) in
            print(collection.estimatedAssetCount)
            
            let fetchResults = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            print(fetchResults)
            
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
//        return self.fetchResultOfCollection?.count ?? 0
//        return self.fetchResult?.count ?? 0
        return self.assetFetchResultss?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListCollectionViewCell.cellId, for: indexPath) as? AlbumListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
       
        let asset: PHAsset = fetchResult?.object(at: indexPath.item) ?? PHAsset()
        
        var assets: PHAsset = (assetFetchResultss?.object(at: indexPath.item)) as! PHAsset
        
        let widthAndHeight: CGFloat = (UIScreen.main.bounds.width / 2) - 15
        
   
        

    
        imageManager.requestImage(for: assets,
                                              targetSize: CGSize(width: widthAndHeight, height: widthAndHeight),
                                              contentMode: .aspectFill,
                                              options: nil) {image, _ in
                                                cell.thumbnailImage = image
                    }
        

        
      


        
//        getThumbnail(cell: cell)
        
        
        return cell
    }
    
    
    
    
}
