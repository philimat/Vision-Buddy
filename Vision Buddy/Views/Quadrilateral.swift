//
//  Quadrilateral.swift
//  Vison Buddy
//
//  Created by Matt Philippi on 3/6/21.
//

import SwiftUI

struct Quadrilateral: Shape {
  
  var cornerPoints : [CGPoint] = []
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.addLines(cornerPoints)

    if cornerPoints.count == 4 {
      path.closeSubpath()
    }
    
    return path
  }
}
