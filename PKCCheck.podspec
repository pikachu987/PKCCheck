#
# Be sure to run `pod lib lint PKCCheck.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PKCCheck'
  s.version          = '0.1.1'
  s.summary          = 'Sound Decible Check And Plug Delegate'

  s.description      = 'Sound Decible Check And Plug Delegate - plug in/ plug out / decibel / permission'

  s.homepage         = 'https://github.com/pikachu987/PKCCheck'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu987@naver.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PKCCheck.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PKCCheck/Classes/**/*'
end
