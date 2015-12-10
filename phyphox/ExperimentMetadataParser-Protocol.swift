//
//  ExperimentMetadataParser-Protocol.swift
//  phyphox
//
//  Created by Jonas Gessner on 10.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import Foundation

protocol ExperimentMetadataParser {
    typealias Output
    
    init(_ data: [NSDictionary])
    
    func parse() -> Output
}
