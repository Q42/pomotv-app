//
//  SearchController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-21.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import MWFeedParser
import SegueManager

class SearchController: UIViewController {

  var allItems: [TalkCollectionViewCell.ViewModel] = []
  var items: [TalkCollectionViewCell.ViewModel] = []

  lazy var segueManager: SegueManager = { SegueManager(viewController: self) }()

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.delegate = self

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(R.nib.talkCollectionViewCell)

    // Add SearchBar height to contentInset
    // How should this be done with AutoLayout/Interface builder?
    collectionView.scrollIndicatorInsets.top += searchBar.frame.height
    collectionView.contentInset.top += searchBar.frame.height

    downloadFeed()
  }

  func downloadFeed() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in

      let delegate = FeedParserDelegate()
      let url = NSURL(string: "http://www.pomo.tv/recent.xml")
      let parser = MWFeedParser(feedURL: url)
      parser.delegate = delegate
      parser.parse()

      dispatch_async(dispatch_get_main_queue()) {
        let items = delegate.feedItems.flatMap(TalkCollectionViewCell.ViewModel.init)
        self?.allItems = items
        self?.items = items
        self?.collectionView?.reloadData()
      }
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segueManager.prepareForSegue(segue)
  }
}

extension SearchController : UISearchBarDelegate {

  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    // Dummy search, while there's no API
    if searchText.isEmpty {
      self.items = allItems
    }
    else {
      self.items = allItems.filter { vm in vm.title.lowercaseString.containsString(searchText.lowercaseString) }
    }
    self.collectionView.reloadData()
  }
}

extension SearchController : UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    let item = items[indexPath.item]

    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.talkCollectionViewCell, forIndexPath: indexPath)!
    cell.configureCell(item)

    return cell
  }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    let item = items[indexPath.item]

    segueManager.performSegue(R.segue.searchController.showTalk) { segue in

      segue.destinationViewController.viewModel = TalkController.ViewModel(
        title: item.title,
        speaker: item.speaker,
        event: nil,
        date: nil,
        youtubeIdentifier: item.youtubeIdentifier
      )
    }
  }
}

@objc
private class FeedParserDelegate : NSObject, MWFeedParserDelegate {

  var feedItems: [MWFeedItem] = []

  @objc func feedParserDidStart(parser: MWFeedParser!) {}

  @objc func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {}

  @objc func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
    feedItems.append(item)
  }

  @objc func feedParserDidFinish(parser: MWFeedParser!) {}
  
  @objc func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {}
}
