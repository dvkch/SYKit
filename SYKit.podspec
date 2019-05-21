Pod::Spec.new do |s|
  s.ios.deployment_target  = '8.0'
  s.tvos.deployment_target = '9.0'
  s.name     = 'SYKit'
  s.version  = '0.0.59'
  s.license  = 'Custom'
  s.summary  = 'UIKit and Foundation tools'
  s.homepage = 'https://github.com/dvkch/SYKit'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYKit.git', :tag => s.version.to_s }
  s.swift_version = "5.0"
  s.source_files = 'Common/*.{h,m,c,swift}'
  s.ios.source_files = 'iOS/*.{h,m,c,swift}'
  s.tvos.source_files = 'tvOS/*.{h,m,c,swift}'

  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
end
