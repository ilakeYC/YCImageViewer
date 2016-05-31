//
//  YCImageViewerCell.swift
//  YCImageViewer
//
//  Created by LakesMac on 16/5/31.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class YCImageViewerCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let imageView = UIImageView(frame: .zero)
    
    var didZoom: ((CGFloat)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.addSubview(imageView)
        imageView.contentMode = .Center
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
        imageView.frame = UIScreen.mainScreen().bounds
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        tapG.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapG)
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        scrollView.setZoomScale(scrollView.zoomScale == 1 ? 2 : 1, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        didZoom?(scale)
    }

}
