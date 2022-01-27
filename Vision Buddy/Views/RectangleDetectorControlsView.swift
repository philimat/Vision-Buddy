//
//  RectangleDetectorControlsView.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 4/9/21.
//

import SwiftUI
import AppKit
import Vision

struct RectangleDetectorControlsView: View {
  
    @EnvironmentObject var rectangleDetector: RectangleDetector
    @Binding var ciImage: CIImage?
  
    var body: some View {
 
                VStack {
                  Toggle("Use CPU Only", isOn: $rectangleDetector.usesCPUOnly)
                  Stepper(value: $rectangleDetector.maximumObservations, in: 0...10, step: 1, onEditingChanged: { _ in self.handleValueChanged() }, label: { Text("Maximum Obervations = \(rectangleDetector.maximumObservations)") })
                  Slider(value: $rectangleDetector.quadratureTolerance, in: 0...90, step: 5.0, onEditingChanged: { _ in self.handleValueChanged() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("90"), label: { Text("Quadrature Tolerance = \(String(format:"%.0f", rectangleDetector.quadratureTolerance))") })
                  Slider(value: $rectangleDetector.minimumSize, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChanged() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Size = \(String(format:"%.1f", rectangleDetector.minimumSize))") })
                  Slider(value: $rectangleDetector.minimumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChanged() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Aspect Ratio = \(String(format:"%.1f", rectangleDetector.minimumAspectRatio))") })
                  Slider(value: $rectangleDetector.maximumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChanged() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Maximum Aspect Ratio = \(String(format:"%.1f", rectangleDetector.maximumAspectRatio))") })
                  Slider(value: $rectangleDetector.minimumConfidence, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChanged() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Confidence = \(String(format:"%.1f", rectangleDetector.minimumConfidence))") })
                  Text("\(self.rectangleDetector.rectangles.count) Rectangles Detected")
                  }
    }
  
  func handleValueChanged() {
    if let ciImage = ciImage {
      self.rectangleDetector.performVisionRequestFor(ciImage: ciImage)
    }
  }
}

struct RectangleDetectorControlsVieww_Previews: PreviewProvider {

    static var previews: some View {
      RectangleDetectorControlsView(ciImage: .constant(nil)).environmentObject(RectangleDetector())
    }
}
