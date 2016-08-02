#
# Be sure to run `pod lib lint AYRuntime.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AYRuntime'
  s.version          = '1.0.1'
  s.summary          = 'BlockSignature/BlockInvocation/RuntimeAddition.'
  s.homepage         = 'https://github.com/alan-yeh/AYRuntime'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alan Yeh' => 'alan@yerl.cn' }
  s.source           = { :git => 'https://github.com/alan-yeh/AYRuntime.git', :tag => s.version.to_s }

  s.ios.deployment_target = '6.0'
  s.source_files = 'AYRuntime/Classes/**/*'
end
