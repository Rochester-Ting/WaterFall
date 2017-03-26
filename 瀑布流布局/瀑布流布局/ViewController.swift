//
//  ViewController.swift
//  瀑布流布局
//
//  Created by Rochester on 26/3/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

import UIKit
let kCellId = "kCellId"
class ViewController: UIViewController {
    var itemCount = 30
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = WaterFallLayout()
        layout.cols = 2
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.dataSource = self
        
        let collectionView : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }


}

extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell

        
    }
    
}
// 上啦加载
extension ViewController : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            itemCount += 30
            collectionView.reloadData()
        }
    }

}
extension ViewController : WaterFallLayoutDataSource{
    func waterFallLayoutDataSource(_ layout: WaterFallLayout, itemIndex: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 45)
    }

}
