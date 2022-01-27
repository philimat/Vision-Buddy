//
//  Extensions.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 3/31/21.
//

import Foundation
import AppKit

extension CGPoint {
  
  func yFlipped() -> CGPoint {
    return CGPoint(x: self.x, y: 1 - self.y)
  }

}

extension NSImage {
  
  convenience init(ciImage: CIImage) {
    let rep = NSCIImageRep(ciImage: ciImage)
    self.init(size: rep.size)
    self.addRepresentation(rep)
  }
  
}

