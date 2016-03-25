//
//  GraphGridView.swift
//  phyphox
//
//  Created by Jonas Gessner on 24.03.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

import UIKit

final class GraphGridView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor(white: 0.0, alpha: 0.5).CGColor
        layer.borderWidth = 1.0
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    var grid: GraphGrid? {
        didSet {
            updateLineViews()
            setNeedsLayout()
        }
    }
    
    private var lineViews: [GraphGridLineView] = []
    
    private func updateLineViews() {
        var neededViews = 0
        if grid != nil {
            if grid!.xGridLines != nil {
                neededViews += grid!.xGridLines!.count
            }
            
            if grid!.yGridLines != nil {
                neededViews += grid!.yGridLines!.count
            }
        }
        
        let delta = lineViews.count-neededViews
        
        if delta > 0 {
            var index = 0
            
            lineViews = lineViews.filter({ (view) -> Bool in
                if index < neededViews {
                    index += 1
                    return true
                }
                else {
                    view.removeFromSuperview()
                    return false
                }
            })
        }
        else if delta < 0 {
            for _ in delta..<0 {
                let view = GraphGridLineView()
                
                addSubview(view)
                
                lineViews.append(view)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if grid != nil {
            var index = 0
            
            let smallestUnit = 1.0/UIScreen.mainScreen().scale
            
            if grid!.xGridLines != nil {
                for line in grid!.xGridLines! {
                    let view = lineViews[index]
                    
                    view.horizontal = false
                    
                    let origin = bounds.size.width*line.relativeValue
                    
                    view.alpha = (origin > 2.0 && origin < bounds.size.width-2.0 ? 1.0 : 0.0) //Hide the line if it is too close the the graph bounds (where fixed lines are shown anyways)
                    
                    view.frame = CGRectMake(origin, 0.0, smallestUnit, bounds.size.height)
                    
                    index += 1
                }
            }
            
            if grid!.yGridLines != nil {
                for line in grid!.yGridLines! {
                    let view = lineViews[index]
                    
                    view.horizontal = true
                    
                    let origin = bounds.size.height*line.relativeValue
                    
                    view.alpha = (origin > 2.0 && origin < bounds.size.height-2.0 ? 1.0 : 0.0) //Hide the line if it is too close the the graph bounds (where fixed lines are shown anyways)
                    
                    view.frame = CGRectMake(0.0, origin, bounds.size.width, smallestUnit)
                    
                    index += 1
                }
            }
        }
    }
}
