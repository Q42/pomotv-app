//
//  TalkCollectionViewCell.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-21.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit

let colors = [
  UIColor(hex: 0x3D576D),
  UIColor(hex: 0x425987),
  UIColor(hex: 0x4B5C77),
  UIColor(hex: 0x424B7A),
  UIColor(hex: 0x45668E),
  UIColor(hex: 0x59758E),
]

class TalkCollectionViewCell : UICollectionViewCell {
  struct ViewModel {
    let title: String
    let youtubeIdentifier: String
  }

  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  func configureCell(viewModel: ViewModel) {
    let ix = Int(arc4random_uniform(UInt32(colors.count)))
    colorView.backgroundColor = colors[ix]
    titleLabel.text = viewModel.title
  }
}
