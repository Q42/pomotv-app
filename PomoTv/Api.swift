//
//  Api.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-22.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import MWFeedParser

class Api {

  func fetchRecents(completion: [MWFeedItem] -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

      let delegate = FeedParserDelegate()
      let url = NSURL(string: "http://www.pomo.tv/recent.xml")
      let parser = MWFeedParser(feedURL: url)
      parser.delegate = delegate
      parser.parse()

      dispatch_async(dispatch_get_main_queue()) {
        completion(delegate.feedItems)
      }
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
