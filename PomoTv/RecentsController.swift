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
        self?.items = delegate.feedItems.flatMap(TalkCollectionViewCell.ViewModel.init)
        self?.collectionView?.reloadData()
      }
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

extension TalkCollectionViewCell.ViewModel {
  init?(item: MWFeedItem) {
    guard let link = item.link else { return nil }
    guard let components = NSURLComponents(string: link) else { return nil }
    guard let title = item.title else { return nil }
    guard let author = item.author else { return nil }

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
    self.speaker = author
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
