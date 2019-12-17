//
//  ViewController.swift
//  2019-12-18-DeletePhotoFromLibrary
//
//  Created by 김광준 on 2019/12/18.
//  Copyright © 2019 VincentGeranium. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

