//
//  ExperimentTranslationsParser.swift
//  phyphox
//
//  Created by Jonas Gessner on 10.12.15.
//  Copyright © 2015 RWTH Aachen. All rights reserved.
//

import UIKit

final class ExperimentTranslationsParser: ExperimentMetadataParser {
    typealias Output = NSArray?
    
    let translations: [NSDictionary]?
    
    required init(_ data: NSDictionary) {
        translations = getElementsWithKey(data, key: "translation") as! [NSDictionary]?
    }
    
    func parse() -> Output {
        return nil
    }
}
