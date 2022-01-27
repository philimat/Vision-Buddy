//
//  FilterPickerVIew.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 4/9/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterPickerVIew: View {
  @Binding var ciFilter : CIFilterType
  
    var body: some View {
      Picker(selection: $ciFilter, label: Text("CIFilter:")) {
        ForEach(CIFilterType.allCases, id: \.self) { filter in
          Text(filter.rawValue)
      }
    }
  }
}

struct FilterPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
      FilterPickerVIew(ciFilter: .constant(CIFilterType.allCases[0]))
    }
}
