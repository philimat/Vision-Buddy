//
//  ImageView.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 3/9/21.
//

import SwiftUI
import AppKit
import Vision

struct ImageView: View {
  
    @State var imageURL: URL?
    @State var ciImage: CIImage?
    @StateObject var rectangleDetector = RectangleDetector()
    @State var showCIFilterSelectionModal = false
    @State var ciFilter = CIFilterType.allCases[0]
  
    var body: some View {
 
        HStack {
                VStack {
                  Spacer()
                  // SwiftUI limits is 10 Subviews so Group is needed here
                    Button(action: self.loadImage, label: {
                      Text("Load Image")
                    })
//                  FilterPickerVIew(ciFilter: $ciFilter)
                  RectangleDetectorControlsView(ciImage: self.$ciImage).environmentObject(rectangleDetector)
                  Spacer()
                }
                .padding()

                  ZStack{
                    Rectangle()
                      .foregroundColor(.white)
                    if self.ciImage != nil {
                    GeometryReader { geometry in
                      Image(nsImage: NSImage(ciImage: ciImage!))
                        .resizable()
                      ForEach(rectangleDetector.rectangles, id: \.self) { result in
                        let resultCornerPoints = [result.bottomLeft, result.topLeft, result.topRight, result.bottomRight, result.bottomLeft].map { $0.yFlipped() }
                        let imageCornerPoints = resultCornerPoints.map { VNImagePointForNormalizedPoint($0, Int(geometry.size.width), Int(geometry.size.height)) }

                        Quadrilateral(cornerPoints: imageCornerPoints)
                          .stroke(Color.red, lineWidth: 2)

                      }
                  }
                    .padding()
//                  .scaledToFit()
                }
              }

          }
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
        let ciImage = CIImage(contentsOf: selectedURL, options: [CIImageOption.applyOrientationProperty: true])
        if let ciImage = ciImage {
          self.ciImage = ciImage
          self.rectangleDetector.performVisionRequestFor(ciImage: ciImage)
        }
      }
    }
  }
}

struct ImageView_Previews: PreviewProvider {

    static var previews: some View {
      ImageView()
    }
}
