//
//  CollectionViewAnimator.swift
//  ARVCollectionViewLayout
//
//  Created by Arvindh Sukumar on 10/06/14.
//  Copyright (c) 2014 Arvindh Sukumar. All rights reserved.
//

import UIKit

class CollectionViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	let zoomAnimationDuration = 0.3
	init() {
		super.init()
	}
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
		return zoomAnimationDuration
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
		let fromVC: CollectionViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as CollectionViewController

		let toVC: FullScreenCollectionViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as FullScreenCollectionViewController
		let container = transitionContext.containerView()

//		toVC.view.alpha = 0
		let cell = fromVC.collectionView.cellForItemAtIndexPath(fromVC.selectedIndexPath)
		let attributes = fromVC.collectionView.layoutAttributesForItemAtIndexPath(fromVC.selectedIndexPath)
		let toAttributes = toVC.collectionView.layoutAttributesForItemAtIndexPath(fromVC.selectedIndexPath)

//		let snapshot : UIView = fromVC.collectionView.resizableSnapshotViewFromRect(attributes.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0))
//		let snapshot : UIView = fromVC.collectionView.resizableSnapshotViewFromRect(cell.frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
		let snapshot : UIView = UIView(frame: cell.contentView.frame)
		snapshot.backgroundColor = cell.contentView.backgroundColor
		snapshot.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		snapshot.frame = container.convertRect(attributes.frame, fromView: fromVC.collectionView)
		let destinationRect = container.convertRect(toAttributes.frame, toView: toVC.collectionView)
		container.addSubview(snapshot)

		UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
			{
				println(snapshot.frame)
				snapshot.frame = toVC.collectionView.frame
//				toVC.view.alpha = 1;
				
			}, completion:
			{
				complete in


				
				transitionContext.completeTransition(complete)
				fromVC.view.removeFromSuperview()
				container.addSubview(toVC.view)

				snapshot.removeFromSuperview()

			})
	}
}