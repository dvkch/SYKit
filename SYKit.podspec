Pod::Spec.new do |s|
  s.ios.deployment_target  = '11.1'
  s.tvos.deployment_target = '11.1'
  s.name     = 'SYKit'
  s.version  = '0.2.4'
  s.license  = 'Custom'
  s.summary  = 'UIKit and Foundation tools'
  s.homepage = 'https://github.com/dvkch/SYKit'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYKit.git', :tag => s.version.to_s }
  s.swift_version = "5.5"
  s.source_files = 'SYKit/**/*.{h,m,c,swift}'

  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
end
