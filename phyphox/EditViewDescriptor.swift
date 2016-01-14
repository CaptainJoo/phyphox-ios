//
//  EditViewDescriptor.swift
//  phyphox
//
//  Created by Jonas Gessner on 14.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import Foundation
import CoreGraphics

public final class EditViewDescriptor: ViewDescriptor {
    let signed: Bool
    let decimal: Bool
    let unit: String
    let factor: Double
    let defaultValue: Double
    
    init(label: String, labelSize: CGFloat, signed: Bool, decimal: Bool, unit: String, factor: Double, defaultValue: Double) {
        self.signed = signed
        self.decimal = decimal
        self.unit = unit
        self.factor = factor
        self.defaultValue = defaultValue
        
        super.init(label: label, labelSize: labelSize)
    }
}

