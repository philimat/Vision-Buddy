//
//  ContentView.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 3/9/21.
//

import SwiftUI
import AppKit
import Vision

struct ContentView: View {
    @ObservedObject var imageLoader = ImageLoader()
    @ObservedObject var rectangleDetector = RectangleDetector()
    var inputImageURL: URL?
  
    var body: some View {
 
        HStack {
                VStack {
                  Spacer()
                  // SwiftUI limits is 10 Subviews so Group is needed here
                  Group {
                    Button(action: self.loadImage, label: {
                      Text("Load Image")
                    })
                    Toggle("Use CPU Only", isOn: $rectangleDetector.usesCPUOnly)
                    Stepper(value: $rectangleDetector.maximumObservations, in: 0...10, step: 1, onEditingChanged: { _ in self.handleValueChange() }, label: { Text("Maximum Obervations = \(rectangleDetector.maximumObservations)") })
                    Slider(value: $rectangleDetector.quadratureTolerance, in: 0...90, step: 5.0, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("90"), label: { Text("Quadrature Tolerance = \(String(format:"%.0f", self.rectangleDetector.quadratureTolerance))") })
                    Slider(value: $rectangleDetector.minimumSize, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Size = \(String(format:"%.1f", self.rectangleDetector.minimumSize))") })
                    Slider(value: $rectangleDetector.minimumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Aspect Ratio = \(String(format:"%.1f", self.rectangleDetector.minimumAspectRatio))") })
                    Slider(value: $rectangleDetector.maximumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Maximum Aspect Ratio = \(String(format:"%.1f", self.rectangleDetector.maximumAspectRatio))") })
                    Slider(value: $rectangleDetector.minimumConfidence, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Confidence = \(String(format:"%.1f", self.rectangleDetector.minimumConfidence))") })
                    Text("\(rectangleDetector.rectangles.count) Rectangles Detected")
                  }
                  Spacer()
                }
            .padding()
                  ZStack{
                    Rectangle()
                      .foregroundColor(.white)
                    if self.imageLoader.image != nil {
                    GeometryReader { geometry in
                      Image(nsImage: self.imageLoader.image!)
                        .resizable()
                      ForEach(rectangleDetector.rectangles, id: \.self) { result in
                        let resultCornerPoints = [result.bottomLeft, result.topLeft, result.topRight, result.bottomRight, result.bottomLeft].map { flipPoint($0) }
                        let imageCornerPoints = resultCornerPoints.map { VNImagePointForNormalizedPoint($0, Int(geometry.size.width), Int(geometry.size.height)) }

                        Quadrilateral(cornerPoints: imageCornerPoints)
                          .stroke(Color.green, lineWidth: 3)

                      }
                  }
                    .padding()
//                  .scaledToFit()
                }
              }

              }
          .onAppear {
            if let inputImageURL = inputImageURL {
              self.imageLoader.loadImage(with: inputImageURL)
            }
      }
    }
  
  func handleValueChange() {
    self.rectangleDetector.performVisionRequest()
  }
  
  func flipPoint(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x, y: 1 - point.y)
  }
  
  func loadImage() {
    
    let panel = NSOpenPanel()
    panel.canChooseFiles = true
    panel.canChooseDirectories = false
    panel.canCreateDirectories = false
    panel.allowsMultipleSelection = false
    
    panel.begin { modalResponse in
      if modalResponse == .OK {
        let selectedURL = panel.urls[0]
        self.imageLoader.loadImage(with: selectedURL)
        self.rectangleDetector.imageURL = selectedURL
        self.rectangleDetector.performVisionRequest()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
      ContentView()
    }
}
