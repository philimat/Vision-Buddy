//
//  RectangleDetector.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 3/31/21.
//

import Foundation
import Vision
import SwiftUI

class RectangleDetector: ObservableObject {
  
  @Published var rectangles = [VNRectangleObservation]()
  @Published var maximumObservations: Int = 0
  @Published var minimumAspectRatio: Float = 0.5
  @Published var maximumAspectRatio: Float = 1.0
  @Published var minimumSize: Float = 0.2
  @Published var quadratureTolerance: Float = 45.0
  @Published var minimumConfidence: Float = 0.5
  @Published var usesCPUOnly: Bool = false
   var revision: Int = VNDetectRectanglesRequestRevision1
  
  func performVisionRequestFor(ciImage: CIImage) {
      rectangles = []
    
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
      DispatchQueue.main.async { [weak self] in
        self?.rectangles = rectangles
      }
  }
  
}
