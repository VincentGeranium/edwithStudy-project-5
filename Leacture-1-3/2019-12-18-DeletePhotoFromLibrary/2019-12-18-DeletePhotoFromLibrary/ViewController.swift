//
//  ViewController.swift
//  2019-12-18-DeletePhotoFromLibrary
//
//  Created by 김광준 on 2019/12/18.
//  Copyright © 2019 VincentGeranium. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver {

    
    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "cell"
    var fetchReseult: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let photoAurhorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAurhorizationStatus {
        case .authorized:
            print("접근 허용")
            self.requestCollection()
            self.tableView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        }
        PHPhotoLibrary.shared().register(self)
    }
    
    func requestCollection() {
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchReseult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchReseult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        let asset: PHAsset = fetchReseult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 30, height: 30),
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    cell.imageView?.image = image
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset: PHAsset = self.fetchReseult[indexPath.row]
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }, completionHandler: nil)
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchReseult)
            else { return }
        
        fetchReseult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
        
    }


}

