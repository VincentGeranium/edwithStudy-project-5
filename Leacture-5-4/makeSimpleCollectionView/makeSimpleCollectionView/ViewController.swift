//
//  ViewController.swift
//  makeSimpleCollectionView
//
//  Created by 김광준 on 2020/01/05.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var numberOfCell: Int = 10
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        
        
        return cell
    }
    
    
}
