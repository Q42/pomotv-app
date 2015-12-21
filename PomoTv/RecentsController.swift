//
//  RecentsController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-20.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import MWFeedParser
import SegueManager

class RecentsController: UICollectionViewController {

  var items: [TalkCollectionViewCell.ViewModel] = []

  lazy var segueManager: SegueManager = { SegueManager(viewController: self) }()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView?.registerNib(R.nib.talkCollectionViewCell)

    Api().fetchRecents { [weak self] feedItems in
      let items = feedItems.flatMap(TalkCollectionViewCell.ViewModel.init)
      self?.items = items
      self?.collectionView?.reloadData()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segueManager.prepareForSegue(segue)
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let item = items[indexPath.item]

    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.talkCollectionViewCell, forIndexPath: indexPath)!
    cell.configureCell(item)

    return cell
  }

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let item = items[indexPath.item]

    segueManager.performSegue(R.segue.recentsController.showTalk) { segue in
      segue.destinationViewController.viewModel = item.talkControllerViewModel
    }
  }
}
