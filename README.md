# PKCCheck

[![Version](https://img.shields.io/cocoapods/v/PKCCheck.svg?style=flat)](http://cocoapods.org/pods/PKCCheck)
[![License](https://img.shields.io/cocoapods/l/PKCCheck.svg?style=flat)](http://cocoapods.org/pods/PKCCheck)
[![Platform](https://img.shields.io/cocoapods/p/PKCCheck.svg?style=flat)](http://cocoapods.org/pods/PKCCheck)

  
<img src="https://github.com/pikachu987/PKCCheck/blob/master/image1.png?raw=true" height="400" width="200" >

<img src="https://github.com/pikachu987/PKCCheck/blob/master/image2.png?raw=true" height="400" width="200" >




## Example



To run the example project, clone the repo, and run `pod install` from the Example directory first.
~~~~
import PKCCheck

self.pkccheck.delegate = self
//self.pkccheck.minDecibelDegree = 45
//self.pkccheck.maxDecibelDegree = 315
self.pkccheck.decibelCheck()

extension ViewController: PKCCheckDelegate{
    func pkcCheckDecibel(_ level: CGFloat, average: CGFloat, degree: CGFloat, radian: CGFloat) {
        self.niddleView.transform = CGAffineTransform(rotationAngle: radian)
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
~~~~

## Requirements

## Installation

PKCCheck is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PKCCheck"
```

## Author

pikachu987, pikachu987@naver.com

## License

PKCCheck is available under the MIT license. See the LICENSE file for more info.
