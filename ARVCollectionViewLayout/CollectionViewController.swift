//
//  CollectionViewController.swift
//  ARVCollectionViewLayout
//
//  Created by Arvindh Sukumar on 08/06/14.
//  Copyright (c) 2014 Arvindh Sukumar. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, ARVCollectionViewLayoutDelegate {
	var itemSizes:CGSize[] = []
	var bgColors:UIColor[] = []
	var selectedIndexPath: NSIndexPath?
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
	
	init(coder aDecoder: NSCoder!) {

		super.init(coder: aDecoder)

		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

		self.collectionView.registerClass(UICollectionViewCell.self , forCellWithReuseIdentifier: reuseIdentifier)
		let layout = self.collectionView.collectionViewLayout as ARVCollectionViewLayout
		layout.delegate = self
		for item in 0..self.collectionView.numberOfItemsInSection(0){
			let height:Int = 100 + Int(arc4random_uniform(100))
			let size = CGSizeMake(145.0, Float(height))
			itemSizes.append(size)
			bgColors.append(UIColor(red: Float(arc4random_uniform(255))/255.0, green: Float(arc4random_uniform(255))/255.0, blue: Float(arc4random_uniform(255))/255.0, alpha: 1))
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "transitionSegue" {
			let destination: FullScreenCollectionViewController = segue.destinationViewController as FullScreenCollectionViewController

			destination.selectedIndexPath = selectedIndexPath
			destination.bgColors = bgColors
		}
		
	}
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    // #pragma mark UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView?) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		return 20;
    }
	
	func itemSize(forItem item: Int, inSection section: Int) -> CGSize! {
		return itemSizes[item]
	}
	
	func itemWidth() -> Float! {
		return 60.0;
	}

    override func collectionView(collectionView: UICollectionView?, cellForItemAtIndexPath indexPath: NSIndexPath?) -> UICollectionViewCell? {
        let cell = collectionView?.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        // Configure the cell
		cell.contentView.backgroundColor = bgColors[indexPath!.row]
    
        return cell
    }

	override func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
		
		println("select \(indexPath.row)")
		selectedIndexPath = indexPath;
		performSegueWithIdentifier("transitionSegue", sender: nil)
	}
	
    // pragma mark <UICollectionViewDelegate>

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView?, shouldHighlightItemAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView?, shouldSelectItemAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView?, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView?, canPerformAction action: String?, forItemAtIndexPath indexPath: NSIndexPath?, withSender sender: AnyObject) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView?, performAction action: String?, forItemAtIndexPath indexPath: NSIndexPath?, withSender sender: AnyObject) {
    
    }
    */

}
