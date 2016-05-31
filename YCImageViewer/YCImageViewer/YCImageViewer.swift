//
//  YCImageViewer.swift
//  YCImageViewer
//
//  Created by LakesMac on 16/5/31.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

@objc protocol YCImageViewerDelegate {
    
    optional func imageViewer(imageViewer: YCImageViewer, didUpdataPage page: Int)
    optional func imageViewerDidTapedView(imageViewer: YCImageViewer)
}

@objc protocol YCImageViewerDataSource {
    
    func numberOfImagesInImageViewer(imageViewer: YCImageViewer) -> Int
    func imageViewer(imageViewer: YCImageViewer, imageSetter: (image: UIImage?, placeHolderImage: UIImage?, index: Int)->(), atIndex: Int)
}

class YCImageViewer: UIView {

    var delegate: YCImageViewerDelegate?
    var dataSource: YCImageViewerDataSource?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupAllViews() {
        collectionView.delegate      = self
        collectionView.dataSource    = self
        collectionView.pagingEnabled = true
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .Horizontal
        collectionView.registerNib(UINib(nibName: "YCImageViewerCell", bundle: nil), forCellWithReuseIdentifier: "YCImageViewerCell")
        addSubview(collectionView)
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapAction)))
        
    }
    
    func tapAction() {
        delegate?.imageViewerDidTapedView?(self)
    }
    
    override func layoutSubviews() {
        collectionView.frame = bounds
    }

    func reloadData() {
        collectionView.reloadData()
    }
    
    func scrollTo(index: Int) {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: index), atScrollPosition: .None, animated: false)
    }
    
    /// Call this func after you have delete this item in data source
    func remove(atIndex: Int) {
        zooms.removeAll()
        collectionView.deleteSections(NSIndexSet(index: atIndex))
    }
    
    
    private var zooms: [NSIndexPath: CGFloat] = [:]
    var currentPage = 0
    var pageForDelete : Int {
        return collectionView.indexPathForCell(collectionView.visibleCells().first!)!.section
    }
}

extension YCImageViewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if dataSource == nil {
            return 0
        }
        return dataSource!.numberOfImagesInImageViewer(self)
    }
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YCImageViewerCell", forIndexPath: indexPath) as! YCImageViewerCell
        
        weak var weakSelf = self
        
        dataSource!.imageViewer(self, imageSetter: { (image, placeHolderImage, index) in
                if weakSelf?.currentPage == index || indexPath.section == index {
                    if image == nil {
                        cell.imageView.image = placeHolderImage
                        cell.scrollView.setZoomScale(1, animated: false)
                        cell.imageView.contentMode = .Center
                        cell.activityView.startAnimating()
                    } else {
                        cell.imageView.image = image
                        cell.activityView.stopAnimating()
                        cell.imageView.contentMode = .ScaleAspectFit
                        if let zoom = weakSelf?.zooms[indexPath] {
                            cell.scrollView.setZoomScale(zoom, animated: false)
                        } else {
                            cell.scrollView.setZoomScale(1, animated: false)
                        }
                    }
                }
            }, atIndex: indexPath.section)
        
        return cell
    }
 
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.imageViewer?(self, didUpdataPage: currentPage)
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.imageViewer?(self, didUpdataPage: currentPage)
    }
}