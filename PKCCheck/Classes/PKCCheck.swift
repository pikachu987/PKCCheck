//
//  PKCCheck.swift
//  PKCCheck
//
//  Created by guanho on 2017. 1. 9..
//  Copyright © 2017년 guanho. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

@objc public protocol PKCCheckDelegate: NSObjectProtocol {
    @objc optional func pkcCheckPlugIn()
    @objc optional func pkcCeckPlugOut()
    @objc optional func pkcCheckSoundErr(_ error: Error)
    @objc optional func pkcCheckDecibelPermissionDenied()
    @objc optional func pkcCheckDecibelPermissionGranted()
    @objc optional func pkcCheckDecibelPermissionUndetermined()
    @objc optional func pkcCheckDecibel(_ level: CGFloat, average: CGFloat, degree: CGFloat, radian: CGFloat)
}

open class PKCCheck {
    // MARK: - properties
    open weak var delegate: PKCCheckDelegate?
    
    open var maxDecibelDegree: CGFloat = 360
    open var minDecibelDegree: CGFloat = 0
    
    fileprivate  var recorder: AVAudioRecorder!
    fileprivate var levelTimer = Timer()
    fileprivate var lowPassResults: Double = 0.0
    fileprivate var decibelArray = [CGFloat]()
    
    public init() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                DispatchQueue.main.async {
                    if description.portType == AVAudioSessionPortHeadphones {
                        self.delegate?.pkcCheckPlugIn?()
                    } else {
                        self.delegate?.pkcCeckPlugOut?()
                    }
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    // MARK: - listener
    dynamic fileprivate func audioRouteChangeListener(_ notification:Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            DispatchQueue.main.async {
                self.delegate?.pkcCheckPlugIn?()
            }
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            DispatchQueue.main.async {
                self.delegate?.pkcCeckPlugOut?()
            }
        default:
            break
        }
    }
    
    dynamic fileprivate func levelTimerCallback() {
        recorder.updateMeters()
        var level : CGFloat!
        let minDecibels: CGFloat = -80
        let decibels = recorder.averagePower(forChannel: 0)
        if decibels < Float(minDecibels){
            level = 0
        }else if decibels >= 0{
            level = 1
        }else{
            let root: Float = 2
            let minAmp = powf(10, 0.05 * Float(minDecibels))
            let inverseAmpRange: Float = 1 / (1 - minAmp)
            let amp = powf(10, 0.05 * decibels)
            let adjAmp: Float = (amp - minAmp) * inverseAmpRange
            level = CGFloat(powf(adjAmp, 1/root))
        }
        level = level * self.maxDecibelDegree + self.minDecibelDegree
        let degree: CGFloat = level/(self.maxDecibelDegree - self.minDecibelDegree)
        let radian: CGFloat = level*CGFloat(M_PI)/180
        self.append(level)
        self.delegate?.pkcCheckDecibel?(level, average: self.decibelArray.average, degree: degree, radian: radian)
    }
    
    
    
    // MARK: - method
    fileprivate func append(_ level: CGFloat){
        if self.decibelArray.count >= 125{
            _ = self.decibelArray.removeFirst()
        }
        self.decibelArray.append(level)
    }
}


// MARK: - check
extension PKCCheck{
    open func decibelCheck(_ secondPerDecibelCheck: Int = 50){
        do{
            if AVAudioSession.sharedInstance().recordPermission() == .denied{
                self.delegate?.pkcCheckDecibelPermissionDenied?()
            }else if AVAudioSession.sharedInstance().recordPermission() == .granted{
                self.delegate?.pkcCheckDecibelPermissionGranted?()
            }else if AVAudioSession.sharedInstance().recordPermission() == .undetermined{
                self.delegate?.pkcCheckDecibelPermissionUndetermined?()
                AVAudioSession.sharedInstance().requestRecordPermission({ (permission) in
                    if permission{
                        self.delegate?.pkcCheckDecibelPermissionGranted?()
                    }else{
                        self.delegate?.pkcCheckDecibelPermissionDenied?()
                    }
                })
            }
            
            let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            let documents: AnyObject = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
            let str : String =  documents.appendingPathComponent("recordTest.caf")
            let url = NSURL.fileURL(withPath: str)
            let recordSettings: [NSObject : AnyObject] = [AVFormatIDKey as NSObject:kAudioFormatAppleIMA4 as AnyObject,
                                                          AVSampleRateKey as NSObject:44100 as AnyObject,
                                                          AVNumberOfChannelsKey as NSObject:1 as AnyObject,
                                                          AVLinearPCMBitDepthKey as NSObject:16 as AnyObject,
                                                          AVLinearPCMIsBigEndianKey as NSObject:false as AnyObject,
                                                          AVLinearPCMIsFloatKey as NSObject:false as AnyObject
                
            ]
            
            self.recorder = try AVAudioRecorder(url:url, settings: recordSettings as! [String : AnyObject])
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
            self.recorder.record()
            
            self.levelTimer = Timer.scheduledTimer(timeInterval: Double(1/secondPerDecibelCheck), target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
        }catch let err{
            self.delegate?.pkcCheckSoundErr?(err)
        }
    }
}






extension Array where Element: FloatingPoint {
    fileprivate var total: Element {
        return reduce(0, +)
    }
    fileprivate var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
