//
//  CollectionViewHideAnimator.swift
//  ARVCollectionViewLayout
//
//  Created by Arvindh Sukumar on 11/06/14.
//  Copyright (c) 2014 Arvindh Sukumar. All rights reserved.
//

import UIKit

class CollectionViewHideAnimator: NSObject, UIViewControllerAnimatedTransitioning {

	let zoomAnimationDuration = 0.3
	init() {
		super.init()
	}
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
		return zoomAnimationDuration
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
		
		let fromVC: FullScreenCollectionViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as FullScreenCollectionViewController
		
		let toVC: CollectionViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as CollectionViewController

		let container = transitionContext.containerView()
		container.addSubview(toVC.view)

		let cell = fromVC.collectionView.visibleCells()[0] as UICollectionViewCell
		let indexPath = fromVC.collectionView.indexPathForCell(cell)
		let attributes = fromVC.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
		let toAttributes = toVC.collectionView.layoutAttributesForItemAtIndexPath(indexPath)

		let snapshot : UIView = UIView(frame: attributes.frame)
		snapshot.backgroundColor = cell.contentView.backgroundColor
		snapshot.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		snapshot.frame = container.convertRect(attributes.frame, fromView: fromVC.collectionView)
		println(snapshot.frame)

		let destinationRect = container.convertRect(toAttributes.frame, fromView: toVC.collectionView)
		container.addSubview(snapshot)

		UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
			{

				snapshot.frame = destinationRect
				//				toVC.view.alpha = 1;
				
			}, completion:
			{
				complete in
				

				transitionContext.completeTransition(complete)
				fromVC.view.removeFromSuperview()

				snapshot.removeFromSuperview()



				

				
				
			})
	}
}

