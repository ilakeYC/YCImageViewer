//
//  ViewController.swift
//  YCImageViewer
//
//  Created by LakesMac on 16/5/31.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, YCImageViewerDelegate, YCImageViewerDataSource {

    let viewer = YCImageViewer(frame: .zero)
    
    override func loadView() {
        view = viewer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewer.delegate = self
        viewer.dataSource = self
    }
    func numberOfImagesInImageViewer(imageViewer: YCImageViewer) -> Int {
        return 2
    }
    
    func imageViewer(imageViewer: YCImageViewer, imageSetter: (image: UIImage?, placeHolderImage: UIImage, index: Int) -> (), atIndex: Int) {
        imageSetter(image: UIImage(named: "123")!, placeHolderImage: UIImage(named: "231")!, index: atIndex)
    }
    
}

