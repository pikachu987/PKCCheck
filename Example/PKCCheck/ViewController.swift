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
    
    @IBOutlet var plugLbl: UILabel!
    @IBOutlet var permissionLbl: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var niddleView: UIImageView!
    @IBOutlet var average: UILabel!
    
    
    let pkccheck = PKCCheck()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.backgroundView.layer.cornerRadius = self.backgroundView.frame.height/2
        self.pkccheck.delegate = self
        //self.pkccheck.minDecibelDegree = 45
        //self.pkccheck.maxDecibelDegree = 315
        self.pkccheck.decibelStart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        self.pkccheck.decibelStart()
    }
    
    @IBAction func stop(_ sender: Any) {
        self.pkccheck.decibelStop()
    }
}

extension ViewController: PKCCheckDelegate{
    func pkcCheckDecibel(_ level: CGFloat, average: CGFloat, degree: CGFloat, radian: CGFloat) {
        self.niddleView.transform = CGAffineTransform(rotationAngle: radian)
        self.average.text = "averageDecibel: \(average)"
    }
    func pkcCheckSoundErr(_ error: Error) {
        print("error: \(error)")
    }
    func pkcCheckPlugIn() {
        self.plugLbl.text = "PlugIn"
    }
    func pkcCeckPlugOut() {
        self.plugLbl.text = "PlugOut"
    }
    func pkcCheckDecibelPermissionDenied() {
        self.permissionLbl.text = "denied"
    }
    func pkcCheckDecibelPermissionGranted() {
        self.permissionLbl.text = "granted"
    }
    func pkcCheckDecibelPermissionUndetermined() {
        self.permissionLbl.text = "undetermined"
    }
}
