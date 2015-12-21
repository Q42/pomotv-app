//
//  RecentController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-20.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import MWFeedParser

class RecentController: UICollectionViewController {

  private let feedParserDelegate = FeedParserDelegate()

  var items: [TalkCollectionViewCell.ViewModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView?.registerNib(R.nib.talkCollectionViewCell)

    let url = NSURL(string: "http://www.pomo.tv/recent.xml")
    let parser = MWFeedParser(feedURL: url)
    parser.delegate = feedParserDelegate
    parser.parse()

    items = feedParserDelegate.feedItems.flatMap(TalkCollectionViewCell.ViewModel.init)
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
}

extension TalkCollectionViewCell.ViewModel {
  init?(item: MWFeedItem) {
    guard let link = item.link else { return nil }
    guard let components = NSURLComponents(string: link) else { return nil }
    guard let title = item.title else { return nil }

    if components.host != "www.youtube.com" {
      print("Dropping \(item), not a youtube link")
      return nil
    }

    guard let identifier = components.queryItems?.filter({ $0.name == "v" }).first?.value
    else {
      print("Dropping \(link), not a youtube link with w= query item")
      return nil
    }

    self.title = title
    self.youtubeIdentifier = identifier
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
