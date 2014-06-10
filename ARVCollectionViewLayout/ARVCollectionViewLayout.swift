//
//  ARVCollectionViewLayout.swift
//  ARVCollectionViewLayout
//
//  Created by Arvindh Sukumar on 08/06/14.
//  Copyright (c) 2014 Arvindh Sukumar. All rights reserved.
//

import UIKit

protocol ARVCollectionViewLayoutDelegate: UICollectionViewDelegateFlowLayout {

	func itemSize(forItem item: Int,inSection section:Int) -> CGSize!
	func itemWidth() -> Float!

}

enum ARVCollectionViewLayoutFlowMode {
	case ARVCollectionViewLayoutFlowModeLeftToRight
	case ARVCollectionViewLayoutFlowModeShortestFirst
}

class ARVCollectionViewLayout: UICollectionViewLayout {
	
	var flowMode = ARVCollectionViewLayoutFlowMode.ARVCollectionViewLayoutFlowModeLeftToRight
	var minimumInteritemSpacing: Float = 10.0
	var minimumLineSpacing: Float = 10.0
	var sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10.0,10.0,10.0,10.0)
	var itemSize: CGSize
	var itemWidth: Float? = 145.0
	var columnCount:Int = 2
	var sectionItemAttributes: UICollectionViewLayoutAttributes[][] = []
	var columnHeights: Float[] = []
	var delegate:ARVCollectionViewLayoutDelegate?
	
	init(coder aDecoder: NSCoder!) {

		self.itemSize = CGSizeMake(145.0, 200.0)

		super.init(coder: aDecoder)
	
		self.minimumInteritemSpacing = 10.0;
		self.minimumLineSpacing = 10.0;
		self.sectionInset = UIEdgeInsetsMake(10.0,5.0,10.0,5.0)

		
		
		
	}
	
	func calculateColumnCount() -> Int {
		let contentWidth = self.collectionViewContentSize().width
		let maxTotalItemWidth = contentWidth - sectionInset.left - sectionInset.right
		let maxColumnCount: Int = Int(maxTotalItemWidth / itemSize.width)
		
		let adjustedWidth =  maxTotalItemWidth - (Float(maxColumnCount - 1) * minimumInteritemSpacing)
		let columnCount = Int(adjustedWidth/itemSize.width)
		return columnCount

	}
	
	func shortestColumnIndex() -> Int {
		let sortedHeights: Float[] = sort(columnHeights)
		let shortestHeight = sortedHeights[0]

		for (index, height) in enumerate(columnHeights) {
			if height == shortestHeight{
				return index
			}
		}
		return 0
	}
	
	func longestColumnIndex() -> Int {
		let sortedHeights: Float[] = sort(columnHeights){$0 > $1}
		let longestHeight = sortedHeights[0]
		
		for (index, height) in enumerate(columnHeights) {
			if height == longestHeight{
				return index
			}
		}
		return 0
	}
	
	func columnToInsertAtUsingLeftToRightFlow(indexPath: NSIndexPath) -> Int {

		return indexPath.row % columnCount
	}
	
	func nextColumnIndex(indexPath: NSIndexPath) -> Int {
		var index: Int?
		switch flowMode {
		case .ARVCollectionViewLayoutFlowModeLeftToRight :
			index = columnToInsertAtUsingLeftToRightFlow(indexPath)
		case .ARVCollectionViewLayoutFlowModeShortestFirst:
			index = shortestColumnIndex()

		default:
			index = columnToInsertAtUsingLeftToRightFlow(indexPath)

		}
		
		return index!
	}
	
	override func collectionViewContentSize() -> CGSize {
		var contentSize = self.collectionView.bounds.size;
		if !columnHeights.isEmpty{
					contentSize.height = columnHeights[longestColumnIndex()] + sectionInset.bottom + sectionInset.top;
		}

		
		return contentSize

		
	}
	
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return false
	}
	
	override func prepareLayout() {
		super.prepareLayout()
		
		itemWidth = delegate?.itemSize(forItem: 0, inSection: 0).width
		let contentWidth = self.collectionViewContentSize().width
		let maxTotalItemWidth = contentWidth - sectionInset.left - sectionInset.right
		let maxColumnCount: Int = Int(maxTotalItemWidth / itemWidth!)
		
		let adjustedWidth =  maxTotalItemWidth - (Float(maxColumnCount - 1) * minimumInteritemSpacing)
		columnCount = Int(adjustedWidth/itemWidth!)
		
		
		for (column) in 0..columnCount{
			columnHeights.insert(0.0, atIndex: column)
		}
		
		let sectionCount = self.collectionView.numberOfSections()
		
		for (section) in 0..sectionCount {
			
			let sectionItemCount = self.collectionView.numberOfItemsInSection(section)
			
			var sectionAttributesArray: UICollectionViewLayoutAttributes[] = []
			
			for item in 0..sectionItemCount {
				let indexPath = NSIndexPath(forRow:item, inSection:section)
				var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
				let columnIndexToInsertAt = nextColumnIndex(indexPath)
				var columnHeight = columnHeights[columnIndexToInsertAt]
				let itemSize: CGSize? = delegate?.itemSize(forItem: item, inSection: section)
				let itemOffsetX = sectionInset.left + (Float(columnIndexToInsertAt) * (minimumInteritemSpacing + itemSize!.width))
				let itemOffsetY = sectionInset.top + columnHeight + minimumLineSpacing
				
				itemAttributes.frame = CGRectMake(itemOffsetX, itemOffsetY, itemWidth!, itemSize!.height)
				let firstCenterX = maxTotalItemWidth/Float(2 * columnCount)
				let centerX = firstCenterX + (Float(columnIndexToInsertAt * 2) * firstCenterX) + sectionInset.left
				
				itemAttributes.center.x = centerX

				
				columnHeight += itemAttributes.frame.height + minimumLineSpacing
				columnHeights[columnIndexToInsertAt] = columnHeight
				
				sectionAttributesArray.insert(itemAttributes, atIndex:item)
				
				
			}
			
			sectionItemAttributes.insert(sectionAttributesArray, atIndex: section)
		}
		
	}
	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes! {

		return (self.sectionItemAttributes[indexPath.section])[indexPath.item];

	}
	
	
	
	override func layoutAttributesForElementsInRect(rect: CGRect) -> AnyObject[]! {
		
		var attributes: UICollectionViewLayoutAttributes[] = []
		for index in 0..self.collectionView.numberOfItemsInSection(0){
			let indexPath = NSIndexPath(forRow:index, inSection:0)
			
			attributes.insert(self.layoutAttributesForItemAtIndexPath(indexPath), atIndex: index)
		}

		return attributes
	}
	

}
