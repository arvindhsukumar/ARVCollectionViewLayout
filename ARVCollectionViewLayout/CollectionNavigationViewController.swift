//
//  CollectionNavigationViewController.swift
//  ARVCollectionViewLayout
//
//  Created by Arvindh Sukumar on 10/06/14.
//  Copyright (c) 2014 Arvindh Sukumar. All rights reserved.
//

import UIKit

class CollectionNavigationViewController: UINavigationController, UINavigationControllerDelegate {
	
	var animator:CollectionViewAnimator
	var hideAnimator: CollectionViewHideAnimator

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		self.animator = CollectionViewAnimator();
		self.hideAnimator = CollectionViewHideAnimator()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.delegate = self

        // Custom initialization
    }
	
	init(coder aDecoder: NSCoder!) {
		self.animator = CollectionViewAnimator()
		self.hideAnimator = CollectionViewHideAnimator()

		super.init(coder: aDecoder)
		self.delegate = self
		
	}
	
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
	
	func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning!{
		
		if (operation == UINavigationControllerOperation.Push)  {
			return self.animator
		}
		else if (operation == UINavigationControllerOperation.Pop) {
			return self.hideAnimator
		}
		return nil
		
		
	}
	
	


    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
