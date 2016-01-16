//
//  ExperimentGraphView.swift
//  phyphox
//
//  Created by Jonas Gessner on 12.01.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

import UIKit

let q = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL)

public class ExperimentGraphView: ExperimentViewModule<GraphViewDescriptor> {
    let graph: JGGraphView
//    let imgView: UIImageView
    
    typealias T = GraphViewDescriptor
    
    required public init(descriptor: GraphViewDescriptor) {
        graph = JGGraphView()

//        imgView = UIImageView()
        
        super.init(descriptor: descriptor)
        
        addSubview(graph)
//        addSubview(imgView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNeedsUpdate", name: DataBufferReceivedNewValueNotification, object: descriptor.yInputBuffer)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var lastIndexXArray: [Double]?
    private var lastCount: Int?
    private var lastXRange: Double?
    private var lastYRange: Double?
    private lazy var path: UIBezierPath = UIBezierPath()
    
    override func update() {
        autoreleasepool({ () -> () in
        var xValues: [Double]
        let yValues: [Double] = descriptor.yInputBuffer.toArray()
        
        let minY = descriptor.yInputBuffer.min
        let maxY = descriptor.yInputBuffer.max
        
        var count = yValues.count
        
        if let xBuf = descriptor.xInputBuffer {
            xValues = xBuf.toArray()
            
            count = min(xValues.count, count)
        }
        else {
            var xC = 0
            
            if lastIndexXArray != nil {
                xC = lastIndexXArray!.count
            }
            
            let delta = count-xC
            
            if delta > 0 && lastIndexXArray == nil {
                lastIndexXArray = []
            }
            
            for i in xC..<count {
                lastIndexXArray!.append(Double(i))
            }
            
            xValues = lastIndexXArray!
        }
        

            if count > 1 {
                if self.lastCount == nil || count > self.lastCount! {
                    let maxX = xValues.last!
                    let minX = xValues.first!
                    
                    let xRange = maxX-minX
                    let yRange = maxY!-minY!
                    
                    if self.lastCount != nil {
                        let scaleX = CGFloat(self.lastXRange!/xRange)
                        let scaleY = CGFloat(self.lastYRange!/yRange)
                        
                        if isnormal(scaleX) && isnormal(scaleY) {
                            self.path.applyTransform(CGAffineTransformMakeScale(scaleX, scaleY))
                        }
                    }
                    
                    self.path = JGGraphDrawer.drawPath(xValues, ys: yValues, minX: minX, maxX: maxX, minY: minY!, maxY: maxY!, count: count, size: self.graph.bounds.size, reusePath: self.path, lastIndex: self.lastCount)
                    
                    self.lastXRange = xRange
                    self.lastYRange = yRange
                    
                    self.lastCount = count
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.graph.path = self.path
                    })
                }
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.graph.path = nil
                })
            }
        })
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(size.width, min(size.width/descriptor.aspectRatio, size.height))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        graph.frame = self.bounds
//        imgView.frame = self.bounds
    }
}

