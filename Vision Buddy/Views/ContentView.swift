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
  
    @State var imageURL: URL?
    @State var rectangles = [VNRectangleObservation]()
    @State var maximumObservations: Int = 0
    @State var minimumAspectRatio: Float = 0.5
    @State var maximumAspectRatio: Float = 1.0
    @State var minimumSize: Float = 0.2
    @State var quadratureTolerance: Float = 45.0
    @State var minimumConfidence: Float = 0.5
    @State var usesCPUOnly: Bool = false
    var revision: Int = VNDetectRectanglesRequestRevision1
  
    var body: some View {
 
        HStack {
                VStack {
                  Spacer()
                  // SwiftUI limits is 10 Subviews so Group is needed here
                  Group {
                    Button(action: self.loadImage, label: {
                      Text("Load Image")
                    })
                    Toggle("Use CPU Only", isOn: $usesCPUOnly)
                    Stepper(value: $maximumObservations, in: 0...10, step: 1, onEditingChanged: { _ in self.handleValueChange() }, label: { Text("Maximum Obervations = \(maximumObservations)") })
                    Slider(value: $quadratureTolerance, in: 0...90, step: 5.0, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("90"), label: { Text("Quadrature Tolerance = \(String(format:"%.0f", quadratureTolerance))") })
                    Slider(value: $minimumSize, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Size = \(String(format:"%.1f", minimumSize))") })
                    Slider(value: $minimumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Aspect Ratio = \(String(format:"%.1f", minimumAspectRatio))") })
                    Slider(value: $maximumAspectRatio, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Maximum Aspect Ratio = \(String(format:"%.1f", maximumAspectRatio))") })
                    Slider(value: $minimumConfidence, in: 0...1, step: 0.1, onEditingChanged: { _ in self.handleValueChange() }, minimumValueLabel: Text("0"), maximumValueLabel: Text("1"), label: { Text("Minimum Confidence = \(String(format:"%.1f", minimumConfidence))") })
                    Text("\(rectangles.count) Rectangles Detected")
                  }
                  Spacer()
                }
            .padding()
                  ZStack{
                    Rectangle()
                      .foregroundColor(.white)
                    if self.imageURL != nil {
                    GeometryReader { geometry in
//                      Image(nsImage: self.imageLoader.image!)
                      Image(nsImage: NSImage(byReferencing: imageURL!))
                        .resizable()
                      ForEach(rectangles, id: \.self) { result in
                        let resultCornerPoints = [result.bottomLeft, result.topLeft, result.topRight, result.bottomRight, result.bottomLeft].map { $0.yFlipped() }
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
    }
  
  func performVisionRequest() {
    guard let imageURL = imageURL else { return }
      rectangles = []
    
    let ciImage = CIImage(contentsOf: imageURL, options: [CIImageOption.applyOrientationProperty: true])!
    let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
      let request = VNDetectRectanglesRequest { request, error in
          self.completedVisionRequest(request, error: error)
      }
      
      request.maximumObservations = maximumObservations
      request.minimumAspectRatio = minimumAspectRatio
      request.maximumAspectRatio = maximumAspectRatio
      request.minimumSize = minimumSize
      request.quadratureTolerance = quadratureTolerance
      request.minimumConfidence = minimumConfidence
      request.usesCPUOnly = usesCPUOnly
      request.revision = revision
      
      DispatchQueue.global().async {
          do {
              try requestHandler.perform([request])
          } catch {
              print("Error: Vision request failed.")
          }
      }
  }
  
  func completedVisionRequest(_ request: VNRequest?, error: Error?) {
      guard let rectangles = request?.results as? [VNRectangleObservation] else {
          guard let error = error else { return }
          print("Error: Vision detection failed with error: \(error.localizedDescription)")
          return
      }
        self.rectangles = rectangles
  }
  
  func handleValueChange() {
    self.performVisionRequest()
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
        imageURL = selectedURL
        self.performVisionRequest()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
      ContentView()
    }
}
