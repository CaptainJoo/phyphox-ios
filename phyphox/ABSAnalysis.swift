//
//  ABSAnalysis.swift
//  phyphox
//
//  Created by Jonas Gessner on 06.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import Foundation

final class ABSAnalysis: ExperimentAnalysis {
    
    override func update() {
        var iterator: IndexingGenerator<Array<Double>>? = nil
        var lastValue: Double = 0.0
        
        //Get value or iterator
        if let val = fixedValues[0] {
            lastValue = val
        }
        else {
            //iterator
            iterator = getBufferForKey(inputs.first!)!.generate()
        }
        
        outputs.first!.clear()
        
        if (iterator == nil) {
            outputs.first!.append(abs(lastValue))
        }
        else {
            while let next = iterator!.next() { //For each output value or at least once for values
                outputs.first!.append(abs(next))
            }
        }
    }
}
