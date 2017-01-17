//
//  ViewController.swift
//  PKCCheck
//
//  Created by pikachu987 on 01/09/2017.
//  Copyright (c) 2017 pikachu987. All rights reserved.
//

import UIKit
import PKCCheck

class ViewController: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var niddleView: UIImageView!
    @IBOutlet var average: UILabel!
    
    
    let pkcCheck = PKCCheck()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.backgroundView.layer.cornerRadius = self.backgroundView.frame.height/2
        self.pkcCheck.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func audioAccessChech(_ sender: Any) {
        self.pkcCheck.audioAccessCheck()
    }
    
    @IBAction func cameraAccessCheck(_ sender: Any) {
        self.pkcCheck.cameraAccessCheck()
    }
    
    @IBAction func photoAccessCheck(_ sender: Any) {
        self.pkcCheck.photoAccessCheck()
    }
    
    @IBAction func plugCheck(_ sender: Any) {
        self.pkcCheck.plugAccessCheck()
    }
    
    @IBAction func decibelStart(_ sender: Any) {
        //self.pkcCheck.minDecibelDegree = 45
        //self.pkcCheck.maxDecibelDegree = 315
        
        self.pkcCheck.decibelStart()
    }
    
    @IBAction func decibelStop(_ sender: Any) {
        self.pkcCheck.decibelStop()
    }
}







extension ViewController: PKCCheckDelegate{
    func pkcCheckAudioPermissionUndetermined() {
        print("audioAccess: undetermined (first approach)")
    }
    
    func pkcCheckAudioPermissionGranted() {
        print("audioAccess: granted")
    }
    
    func pkcCheckAudioPermissionDenied() {
        print("audioAccess: denied")
        self.pkcCheck.permissionsChange()
    }
    
    
    
    func pkcCheckCameraPermissionUndetermined() {
        print("cameraAccess: undetermined (first approach)")
    }
    
    func pkcCheckCameraPermissionGranted() {
        print("cameraAccess: granted")
    }
    
    func pkcCheckCameraPermissionDenied() {
        print("cameraAccess: denied")
        self.pkcCheck.permissionsChange()
    }
    
    
    
    func pkcCheckPhotoPermissionUndetermined() {
        print("photoAccess: undetermined (first approach)")
    }
    
    func pkcCheckPhotoPermissionGranted() {
        print("photoAccess: granted")
    }
    
    func pkcCheckPhotoPermissionDenied() {
        print("photoAccess: denied")
        self.pkcCheck.permissionsChange()
    }
    
    
    
    func pkcCheckPlugIn() {
        print("plugIn")
    }
    
    func pkcCeckPlugOut() {
        print("plugOut")
    }
    
    
    
    func pkcCheckDecibel(_ level: CGFloat, average: CGFloat, degree: CGFloat, radian: CGFloat) {
        self.niddleView.transform = CGAffineTransform(rotationAngle: radian)
        self.average.text = "averageDecibel: \(average)"
    }
    func pkcCheckSoundErr(_ error: Error) {
        print("sound error: \(error)")
    }
}
