//
//  ImageZoomViewController.swift
//  Bar-Button-Item-Example
//
//  Created by 김광준 on 2020/01/02.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController {
    
    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        requestImage(imageManager: imageManager)
    }
    
    func requestImage(imageManager: PHCachingImageManager) {
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    self.imageView.image = image
        })
    }

}

extension ImageZoomViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
