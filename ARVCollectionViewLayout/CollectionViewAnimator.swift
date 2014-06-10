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

		let attributes = fromVC.collectionView.layoutAttributesForItemAtIndexPath(fromVC.selectedIndexPath)
		let snapshot : UIView = fromVC.collectionView.resizableSnapshotViewFromRect(attributes.frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
		snapshot.frame = container.convertRect(attributes.frame, fromView: fromVC.collectionView)
		container.addSubview(snapshot)

		UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
			{
				println(snapshot.frame)
				snapshot.frame = toVC.view.frame
//				toVC.view.alpha = 1;
				
			}, completion:
			{
				complete in
				println(complete)
//				fromVC.view.transform = CGAffineTransformIdentity;
				
				transitionContext.completeTransition(complete)
				fromVC.view.removeFromSuperview()
				container.addSubview(toVC.view)

				snapshot.removeFromSuperview()

			})
	}
}