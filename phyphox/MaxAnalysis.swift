//
//  MaxAnalysis.swift
//  phyphox
//
//  Created by Jonas Gessner on 06.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import Foundation
import Surge

final class MaxAnalysis: ExperimentAnalysisModule {
    var xIn: DataBuffer?
    var yIn: DataBuffer!
    
    var maxOut: DataBuffer?
    var positionOut: DataBuffer?
    
    override init(inputs: [ExperimentAnalysisDataIO], outputs: [ExperimentAnalysisDataIO], additionalAttributes: [String : AnyObject]?) {
        for input in inputs {
            if input.asString == "x" {
                xIn = input.buffer
            }
            else if input.asString == "y" {
                yIn = input.buffer
            }
            else {
                print("Error: Invalid analysis input: \(input.asString)")
            }
        }
        
        for output in outputs {
            if output.asString == "max" {
                maxOut = output.buffer
            }
            else if output.asString == "position" {
                positionOut = output.buffer
            }
            else {
                print("Error: Invalid analysis output: \(output.asString)")
            }
        }
        
        super.init(inputs: inputs, outputs: outputs, additionalAttributes: additionalAttributes)
    }
    
    
    override func update() {
        var max = -Double.infinity
        var x: Double? = nil
        
        for (i, value) in yIn.enumerate() {
            if value > max {
                max = value
                
                if let v = xIn?.objectAtIndex(i) {
                    x = v
                }
                else {
                    x = Double(i)
                }
            }
        }
        
        if maxOut != nil {
            maxOut!.append(max)
        }
        
        if positionOut != nil {
            positionOut!.append(x)
        }
    }
}
