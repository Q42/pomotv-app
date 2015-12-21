//
//  TalkCollectionViewCell+MWFeedItem.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-22.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import MWFeedParser

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