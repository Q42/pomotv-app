//
//  TalkController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-21.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import AlamofireImage
import youtube_ios_player_helper

class TalkController: UIViewController {

  struct ViewModel {
    let title: String
    let speaker: String
    let event: String?
    let date: NSDate?
    let youtubeIdentifier: String
  }

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var playerView: YTPlayerView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!


  var viewModel: ViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    playerView.hidden = true
    playerView.delegate = self
    playerView.loadWithVideoId(viewModel.youtubeIdentifier, playerVars: [ "playsinline": 1 ])

    let url = NSURL(string: "https://img.youtube.com/vi/\(viewModel.youtubeIdentifier)/mqdefault.jpg")!
    imageView.af_setImageWithURL(url)

    self.title = viewModel.title
    titleLabel.text = viewModel.title
    subtitleLabel.text = "By \(viewModel.speaker)"

    if let event = viewModel.event {
      subtitleLabel.text = "By \(viewModel.speaker) at \(event)"
    }

    if let date = viewModel.date {
      let formatter = NSDateFormatter()
      formatter.dateStyle = NSDateFormatterStyle.LongStyle
      dateLabel.text = formatter.stringFromDate(date)
    }
    else {
      dateLabel.removeFromSuperview()
    }
  }
}

extension TalkController : YTPlayerViewDelegate {
  func playerViewDidBecomeReady(playerView: YTPlayerView!) {

    playerView.hidden = false

    playerView.alpha = 0
    UIView.animateWithDuration(0.3) {
      playerView.alpha = 1
      self.activityIndicator.removeFromSuperview()
    }
  }
}
