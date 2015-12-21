//
//  RecentViewController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-20.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import MWFeedParser

class RecentViewController: UIViewController {

  private let feedParserDelegate = FeedParserDelegate()

  override func viewDidLoad() {
    super.viewDidLoad()

    let url = NSURL(string: "http://www.pomo.tv/recent.xml")
    let parser = MWFeedParser(feedURL: url)
    parser.delegate = feedParserDelegate
    parser.parse()

    for item in feedParserDelegate.feedItems {
      print(item)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
