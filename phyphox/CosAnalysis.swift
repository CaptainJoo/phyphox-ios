//
//  CosAnalysis.swift
//  phyphox
//
//  Created by Jonas Gessner on 06.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import Foundation

final class CosAnalysis: UpdateValueAnalysis {
    
    override func update() {
        updateWithMethod(cos)
    }
}

