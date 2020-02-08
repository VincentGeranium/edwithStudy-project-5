//
//  AlbumModel.swift
//  ProjectD_MyAlbum
//
//  Created by 김광준 on 2020/01/24.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct AlbumModel {
    let name: String
    let count: Int
    let collection: PHAssetCollection
    let asset: PHAsset
    
    init(name: String, count: Int, collection: PHAssetCollection, asset: PHAsset) {
        self.name = name
        self.count = count
        self.collection = collection
        self.asset = asset
    }
}
