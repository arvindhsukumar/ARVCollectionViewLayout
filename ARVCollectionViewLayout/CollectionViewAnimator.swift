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
	override init() {
		super.init()
	}
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return zoomAnimationDuration
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromVC: CollectionViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as CollectionViewController

		let toVC: FullScreenCollectionViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as FullScreenCollectionViewController
		let container = transitionContext.containerView()

		let cell = fromVC.collectionView!.cellForItemAtIndexPath(fromVC.selectedIndexPath!)
		let attributes = fromVC.collectionView!.layoutAttributesForItemAtIndexPath(fromVC.selectedIndexPath!)
		let toAttributes = toVC.collectionView!.layoutAttributesForItemAtIndexPath(fromVC.selectedIndexPath!)

		let snapshot : UIView = UIView()
		snapshot.backgroundColor = cell!.contentView.backgroundColor
		snapshot.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		snapshot.frame = container.convertRect(attributes!.frame, fromView: fromVC.collectionView)
		let destinationRect = toVC.view.convertRect(toAttributes!.frame, fromView: toVC.collectionView)
		container.addSubview(snapshot)

		UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
			{
				println(destinationRect)
				snapshot.frame = destinationRect
				
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