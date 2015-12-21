//
//  UIColor+Pomo.swift
//  PomoTv
//
//  Created by Tom Lokhorst on 2015-12-20.
//  Copyright © 2015 pomo.tv. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hex: Int) {
    self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0xFF) / 255.0,
      alpha: 1)
  }

  static func darkTintColor() -> UIColor {
    return UIColor(hex: 0x3C4F5D)
  }

  static func lightTintColor() -> UIColor {
    return UIColor(hex: 0xB0CADB)
  }
}