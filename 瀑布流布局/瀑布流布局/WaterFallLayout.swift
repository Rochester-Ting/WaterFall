//
//  WaterFallLayout.swift
//  瀑布流布局
//
//  Created by Rochester on 26/3/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

import UIKit
protocol WaterFallLayoutDataSource : class {
    func waterFallLayoutDataSource(_ layout : WaterFallLayout, itemIndex : Int) -> CGFloat
}
class WaterFallLayout: UICollectionViewFlowLayout {
    var cols = 2
    weak var dataSource : WaterFallLayoutDataSource?
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxHeight : CGFloat = self.sectionInset.top + self.sectionInset.bottom
    fileprivate lazy var heights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}
// MARK - 准备cell 所有的布局
extension WaterFallLayout{
    override func prepare() {
        super.prepare()
        // 检验collectionView
        guard let collectionView = collectionView else {
            return
        }
//        attributes.removeAll()
        // 获取所有cell的个数  假设只有一组
        let count = collectionView.numberOfItems(inSection: 0)
        print(count)
        // 遍历所有的cell 给cell设置UICollectionViewLayoutAttributes
        // 几列
        
        // 设置cell的宽度
        let itemW = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * (CGFloat(cols) - 1)) / CGFloat(cols)
        
        // 遍历
        for i in attributes.count..<count {
            // 创建UICollectionViewLayoutAttributes 并传入indexPath
            let indexPath = IndexPath(item: i, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 高度随机50~200
//            let itemH = CGFloat(arc4random_uniform(150) + 50)
            let itemH = dataSource?.waterFallLayoutDataSource(self, itemIndex: i) ?? 100
            // 取出最低的高度
            let minH = heights.min()!
            // 最低高度的列
            let minIndex = heights.index(of: minH)!
            // 计算itemY 
            let itemY = minH
            attribute.frame = CGRect(x: sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(minIndex), y: itemY, width: itemW, height: itemH)
            attributes.append(attribute)
            // 改变heights里最小值
            heights[minIndex] = attribute.frame.maxY + minimumLineSpacing
        }
        maxHeight = heights.max()!
    }
}
// MARK - 告知系统所有的布局
extension WaterFallLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("attributes.count\(attributes.count)")
        return attributes
    }
}
// MARK - 告知系统滚动的范围
extension WaterFallLayout{
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: maxHeight)
    }
}
