//
//  ViewController.swift
//  Bar-Button-Item-Example
//
//  Created by 김광준 on 2019/12/31.
//  Copyright © 2019 VincentGeranium. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "cell"
    var fetchResult: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    @IBAction func touchUpRefreshButton(_ sender: UIBarButtonItem) {
        self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        photoLibraryAutorization(photoAutorizationStatus: photoAuthorizationStatus)
        
    }
    
    
    private func photoLibraryAutorization(photoAutorizationStatus: PHAuthorizationStatus) {
        switch photoAutorizationStatus {
        case .authorized:
            print("접근 허용")
            self.requestCollection()
            self.tableView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("응답 없음")
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    print("접근 허용")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("접근 불허")
                default: break
                }
            }
        case .restricted:
            print("접근 제한")
        }
        PHPhotoLibrary.shared().register(self)
    }
    
    private func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                                                   subtype: .smartAlbumUserLibrary,
                                                                                                   options: nil)
        
        guard let cameraRollColletcion = cameraRoll.firstObject else { return }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollColletcion, options: fetchOptions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageZoomViewController = segue.destination as? ImageZoomViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        nextViewController.asset = self.fetchResult[index.row]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 30, height: 30),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: {image, _ in cell.imageView?.image = image
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset = self.fetchResult[indexPath.row]
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }, completionHandler: nil)
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
}
