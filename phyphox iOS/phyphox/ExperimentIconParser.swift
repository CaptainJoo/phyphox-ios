//
//  ExperimentIconParser.swift
//  phyphox
//
//  Created by Jonas Gessner on 15.12.15.
//  Copyright © 2015 Jonas Gessner. All rights reserved.
//  By Order of RWTH Aachen.
//

import UIKit

final class ExperimentIconParser: ExperimentMetadataParser {
    let data: AnyObject
    
    required init(_ data: AnyObject) {
        self.data = data
    }
    
    func parse() -> ExperimentIcon? {
        if var title = data as? String {
            if title.characters.count > 2 {
                title = title.substring(to: title.characters.index(title.startIndex, offsetBy: 2))
            }
        
            return ExperimentIcon(string: title.uppercased(), image: nil)
        }
        else if let icon = data as? NSDictionary {
            let attributes = icon[XMLDictionaryAttributesKey] as! [String: AnyObject]?
            
            let string = icon[XMLDictionaryTextKey] as? String ?? ""
            
            if stringFromXML(attributes, key: "format", defaultValue: "string") == "base64" {
                let data = Data(base64Encoded: string, options: [])!
                let image = UIImage(data: data)
                
                return ExperimentIcon(string: nil, image: image)
            }
            else {
                return ExperimentIcon(string: string, image: nil)
            }
        }
        
        return nil
    }
}

