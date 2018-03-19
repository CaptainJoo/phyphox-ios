//
//  ButtonViewDescriptor.swift
//  phyphox
//
//  Created by Sebastian Kuhlen on 13.11.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

import Foundation
import CoreGraphics

final class ButtonViewDescriptor: ViewDescriptor {
    let inputs: [ExperimentAnalysisDataIO]
    let outputs: [DataBuffer]
    
    init(label: String, translation: ExperimentTranslationCollection?, inputs: [ExperimentAnalysisDataIO], outputs: [DataBuffer]) {
        self.inputs = inputs
        self.outputs = outputs
        
        super.init(label: label, translation: translation)
    }
    
    override func generateViewHTMLWithID(_ id: Int) -> String {
        return "<div style=\"font-size: 105%;\" class=\"buttonElement\" id=\"element\(id)\"><button onclick=\"$.getJSON('control?cmd=trigger&element=\(id)')\">\(localizedLabel)</button></div>"
    }
}
