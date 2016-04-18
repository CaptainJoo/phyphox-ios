//
//  ExperimentInfoView.swift
//  phyphox
//
//  Created by Jonas Gessner on 12.01.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

import UIKit

final class ExperimentInfoView: ExperimentViewModule<InfoViewDescriptor> {
    required init(descriptor: InfoViewDescriptor) {
        super.init(descriptor: descriptor)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return label.sizeThatFits(size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}
