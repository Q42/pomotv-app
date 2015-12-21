//
//  TalkViewController.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-21.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class TalkViewController: UIViewController {

  @IBOutlet weak var playerView: YTPlayerView!

  override func viewDidLoad() {
    super.viewDidLoad()

    playerView.loadWithVideoId("sP156LW5BVs", playerVars: [ "playsinline": 1 ])
  }
}

