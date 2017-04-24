//
//  MotionSession.swift
//  phyphox
//
//  Created by Jonas Gessner on 05.12.15.
//  Copyright © 2015 Jonas Gessner. All rights reserved.
//  By Order of RWTH Aachen.
//

import Foundation
import CoreMotion

func ==(x: MotionSessionReceiver, y: MotionSessionReceiver) -> Bool {
    return x === y
}

class MotionSessionReceiver: Hashable {
    var hashValue: Int {
        return Unmanaged.passUnretained(self).toOpaque().hashValue
    }
}

final class MotionSession {
    fileprivate lazy var motionManager = CMMotionManager()
    fileprivate lazy var altimeter = CMAltimeter()
    
    var calibratedMagnetometer = true
    
    fileprivate(set) var altimeterRunning = false
    fileprivate(set) var accelerometerRunning = false
    fileprivate(set) var gyroscopeRunning = false
    fileprivate(set) var magnetometerRunning = false
    fileprivate(set) var deviceMotionRunning = false
    fileprivate(set) var proximityRunning = false
    
    fileprivate var altimeterReceivers: [MotionSessionReceiver: (_ data: CMAltitudeData?, _ error: NSError?) -> Void] = [:]
    fileprivate var accelerometerReceivers: [MotionSessionReceiver: (_ data: CMAccelerometerData?, _ error: NSError?) -> Void] = [:]
    fileprivate var gyroscopeReceivers: [MotionSessionReceiver: (_ data: CMGyroData?, _ error: NSError?) -> Void] = [:]
    fileprivate var magnetometerReceivers: [MotionSessionReceiver: (_ data: CMMagnetometerData?, _ error: NSError?) -> Void] = [:]
    fileprivate var deviceMotionReceivers: [MotionSessionReceiver: (_ deviceMotion: CMDeviceMotion?, _ error: NSError?) -> Void] = [:]
    fileprivate var proximityReceivers: [MotionSessionReceiver: (_ proximityState: Bool) -> Void] = [:]
    
    fileprivate func makeQueue() -> OperationQueue {
        let q = OperationQueue()
        
        q.maxConcurrentOperationCount = 1 //FIFO/serial queue
        q.qualityOfService = .userInitiated
        
        return q
    }
    
    fileprivate static let instance = MotionSession()
    
    class func sharedSession() -> MotionSession {
        return instance
    }
    
    //MARK: - Altimeter
    
    var altimeterAvailable: Bool {
        return CMAltimeter.isRelativeAltitudeAvailable()
    }
    
    func getAltimeterData(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ data: CMAltitudeData?, _ error: NSError?) -> Void) -> Bool {
        if altimeterAvailable {
            altimeterReceivers[receiver] = handler
            
            if !altimeterRunning {
                altimeterRunning = true
                
                altimeter.startRelativeAltitudeUpdates(to: makeQueue(), withHandler: { [unowned self] (data, error) in
                    for (_, h) in self.altimeterReceivers {
                        h(data, error as NSError?)
                    }
                    })
            }
            
            return true
        }
        
        return false
    }
    
    func stopAltimeterUpdates(_ receiver: MotionSessionReceiver) {
        altimeterReceivers.removeValue(forKey: receiver)
        
        if altimeterReceivers.count == 0 && altimeterRunning {
            altimeterRunning = false
            self.altimeter.stopRelativeAltitudeUpdates()
        }
    }
    
    
    //MARK: - Accelerometer
    
    var accelerometerAvailable: Bool {
        return motionManager.isAccelerometerAvailable
    }
    
    func getAccelerometerData(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ data: CMAccelerometerData?, _ error: NSError?) -> Void) -> Bool {
        if accelerometerAvailable {
            accelerometerReceivers[receiver] = handler
            
            if !accelerometerRunning {
                accelerometerRunning = true
                
                motionManager.accelerometerUpdateInterval = interval
                motionManager.startAccelerometerUpdates(to: makeQueue(), withHandler: { [unowned self] (data, error) in
                    for (_, h) in self.accelerometerReceivers {
                        h(data, error as NSError?)
                    }
                    })
            }
            
            return true
        }
        
        return false
    }
    
    func stopAccelerometerUpdates(_ receiver: MotionSessionReceiver) {
        accelerometerReceivers.removeValue(forKey: receiver)
        
        if accelerometerReceivers.count == 0 && accelerometerRunning {
            accelerometerRunning = false
            self.motionManager.stopAccelerometerUpdates()
        }
    }
    
    //MARK: - Gyroscope
    
    var gyroAvailable: Bool {
        return motionManager.isGyroAvailable
    }
    
    func getGyroData(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ data: CMGyroData?, _ error: NSError?) -> Void) -> Bool {
        if gyroAvailable {
            gyroscopeReceivers[receiver] = handler
            
            if !gyroscopeRunning {
                gyroscopeRunning = true
                
                motionManager.gyroUpdateInterval = interval
                motionManager.startGyroUpdates(to: makeQueue(), withHandler: { [unowned self] (data, error) in
                    for (_, h) in self.gyroscopeReceivers {
                        h(data, error as NSError?)
                    }
                    })
            }
            
            return true
        }
        
        return false
    }
    
    func stopGyroUpdates(_ receiver: MotionSessionReceiver) {
        gyroscopeReceivers.removeValue(forKey: receiver)
        
        if gyroscopeReceivers.count == 0 && gyroscopeRunning {
            gyroscopeRunning = false
            self.motionManager.stopGyroUpdates()
        }
    }
    
    
    //MARK: - Magnetometer
    
    var magnetometerAvailable: Bool {
        return motionManager.isMagnetometerAvailable
    }
    
    func getMagnetometerData(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ data: CMMagnetometerData?, _ error: NSError?) -> Void) -> Bool {
        if magnetometerAvailable {
            magnetometerReceivers[receiver] = handler
            
            if !magnetometerRunning {
                magnetometerRunning = true
                
                motionManager.magnetometerUpdateInterval = interval
                motionManager.startMagnetometerUpdates(to: makeQueue(), withHandler: { [unowned self] (data, error) in
                    for (_, h) in self.magnetometerReceivers {
                        h(data, error as NSError?)
                    }
                    })
            }
            
            return true
        }
        
        return false
    }
    
    func stopMagnetometerUpdates(_ receiver: MotionSessionReceiver) {
        magnetometerReceivers.removeValue(forKey: receiver)
        
        if magnetometerReceivers.count == 0 && magnetometerRunning {
            magnetometerRunning = false
            motionManager.stopMagnetometerUpdates()
        }
    }
    
    //MARK: - Device Motion
    
    var deviceMotionAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    func getDeviceMotion(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ deviceMotion: CMDeviceMotion?, _ error: NSError?) -> Void) -> Bool {
        if deviceMotionAvailable {
            deviceMotionReceivers[receiver] = handler
            
            if !deviceMotionRunning {
                deviceMotionRunning = true
                
                motionManager.deviceMotionUpdateInterval = interval
                motionManager.showsDeviceMovementDisplay = true
                if calibratedMagnetometer {
                    motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: makeQueue(), withHandler: { [unowned self] (motion, error) in
                        for (_, h) in self.deviceMotionReceivers {
                            h(motion, error as NSError?)
                        }
                        })
                } else {
                    motionManager.startDeviceMotionUpdates(to: makeQueue(), withHandler: { [unowned self] (motion, error) in
                        for (_, h) in self.deviceMotionReceivers {
                            h(motion, error as NSError?)
                        }
                        })
                }
            }
            
            return true
        }
        
        return false
    }
    
    func stopDeviceMotionUpdates(_ receiver: MotionSessionReceiver) {
        deviceMotionReceivers.removeValue(forKey: receiver)
        
        if deviceMotionReceivers.count == 0 && deviceMotionRunning {
            deviceMotionRunning = false
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    //MARK: - Proximity sensor
    
    var proximityAvailable: Bool {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        let available = device.isProximityMonitoringEnabled
        device.isProximityMonitoringEnabled = false
        return available
    }
    
    @objc func proximityChanged(_ notification: Notification) {
        let state = (notification.object as! UIDevice).proximityState
        for (_, h) in self.proximityReceivers {
            h(state)
        }
    }
    
    func getProximityData(_ receiver: MotionSessionReceiver, interval: TimeInterval = 0.1, handler: @escaping (_ proximity: Bool) -> Void) -> Bool {
        if proximityAvailable {
            proximityReceivers[receiver] = handler
            
            if !proximityRunning {
                proximityRunning = true
                
                let device = UIDevice.current
                device.isProximityMonitoringEnabled = true
                NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
                proximityChanged(Notification(name: Notification.Name(rawValue: "First value"), object: device))
            }
            
            return true
        }
        
        return false
    }
    
    func stopProximityUpdates(_ receiver: MotionSessionReceiver) {
        proximityReceivers.removeValue(forKey: receiver)
        print("Stopping")
        if proximityReceivers.count == 0 && proximityRunning {
            print("Full stop")
            proximityRunning = false
            NotificationCenter.default.removeObserver(self)
            UIDevice.current.isProximityMonitoringEnabled = false
        }
    }
    
}
