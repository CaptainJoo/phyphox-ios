//
//  GaussSmoothAnalysis.swift
//  phyphox
//
//  Created by Jonas Gessner on 06.12.15.
//  Copyright © 2015 Jonas Gessner. All rights reserved.
//  By Order of RWTH Aachen.
//

import Foundation
import Accelerate

final class GaussSmoothAnalysis: ExperimentAnalysisModule {
    fileprivate var calcWidth: Int = 0
    fileprivate var kernel: [Float] = []
    
    fileprivate var sigma: Double = 0.0 {
        didSet {
            calcWidth = Int(round(sigma*3.0))
            
            kernel.removeAll()
            kernel.reserveCapacity(2*calcWidth+1)
            
            let c = Float(sigma*sigma)
            var sum = Float(0)
            
            for i in -calcWidth...calcWidth {
                let d = Float(i*i)
                
                let value = expf(-d/(2.0*c))
                sum += value
                kernel.append(value)
            }
            for i in 0..<kernel.count {
                kernel[i] /= sum
            }
        }
    }
    
    override init(inputs: [ExperimentAnalysisDataIO], outputs: [ExperimentAnalysisDataIO], additionalAttributes: [String : AnyObject]?) throws {
        sigma = 1.0
        try super.init(inputs: inputs, outputs: outputs, additionalAttributes: additionalAttributes)
        defer {
            sigma = floatTypeFromXML(additionalAttributes, key: "sigma", defaultValue: 3.0)
        }
    }
    
    override func update() {
        #if DEBUG_ANALYSIS
            debug_noteInputs(["sigma" : sigma, "calcWidth" : calcWidth, "kernel" : kernel])
        #endif
        
        var input = self.inputs.first!.buffer!.toArray().map { Float($0) }
        
        let count = input.count
        
        let outputData = UnsafeMutablePointer<Float>.allocate(capacity: count)
        
        var inImg = vImage_Buffer(data: &input, height: 1, width: vImagePixelCount(count), rowBytes: count*MemoryLayout<Float>.size)
        var outImg = vImage_Buffer(data: outputData, height: 1, width: vImagePixelCount(count), rowBytes: count*MemoryLayout<Float>.size)
        
        vImageConvolve_PlanarF(&inImg, &outImg, nil, 0, 0, kernel, 1, UInt32(kernel.count), Pixel_F(0.0), vImage_Flags(kvImageTruncateKernel))
        
        let result = Array(UnsafeBufferPointer(start: unsafeBitCast(outImg.data, to: UnsafeMutablePointer<Float>.self), count: count)).map(Double.init)
        
        outputData.deinitialize()
        outputData.deallocate(capacity: count)
        
        #if DEBUG_ANALYSIS
            debug_noteOutputs(result)
        #endif
        
        for output in outputs {
            if output.clear {
                output.buffer!.replaceValues(result)
            }
            else {
                output.buffer!.appendFromArray(result)
            }
        }
    }
}
