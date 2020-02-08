//
//  AlbumListCollectionViewCell.swift
//  ProjectD_MyAlbum
//
//  Created by 김광준 on 2020/01/12.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class AlbumListCollectionViewCell: UICollectionViewCell {
    
//    var thumbnailImage: UIImage? {
//        didSet {
//            guard let thumbnailImage = thumbnailImage else { return }
//            thumbnailImageView.image = thumbnailImage
//        }
//    }
    
    static let cellId = "albumListCollectionViewCell"
    
//    var thumbnailImage
    
//    private let thumbnailImageView: UIImageView = {
//        let imageView = UIImageView()
//
//        return imageView
//    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .red
        self.thumbnailImageView.backgroundColor = .white
        
        setupThumbnailImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        let guide = contentView.safeAreaLayoutGuide
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: guide.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
    
}
