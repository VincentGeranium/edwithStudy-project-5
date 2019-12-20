//
//  ViewController.swift
//  AsyncExample
//
//  Created by 김광준 on 2019/12/20.
//  Copyright © 2019 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func touchUpDownloadButton(_ sender: UIButton) {
        // 웹에서 이미지 다운로드 -> 이미지 뷰에 셋팅
        //        https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg
        
        let imageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg")!
            
        
        
        let imageData: Data = try! Data.init(contentsOf: imageURL)
        let image = UIImage(data: imageData)!
        
        self.imageView.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

