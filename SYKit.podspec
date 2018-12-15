Pod::Spec.new do |s|
  s.ios.deployment_target  = '5.0'
  s.tvos.deployment_target = '9.0'
  s.name     = 'SYKit'
  s.version  = '0.0.39'
  s.license  = 'Custom'
  s.summary  = 'UIKit and Foundation tools'
  s.homepage = 'https://github.com/dvkch/SYKit'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYKit.git', :tag => s.version.to_s }
  s.source_files = 'Common/*.{h,m,c}'
  s.ios.source_files = 'iOS/*.{h,m,c}'
  s.tvos.source_files = 'tvOS/*.{h,m,c}'

  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }

  s.ios.dependency 'JGMethodSwizzler'
end
