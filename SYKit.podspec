Pod::Spec.new do |s|
  s.ios.deployment_target = '5.0'
  s.name     = 'SYKit'
  s.version  = '0.0.6'
  s.license  = 'Custom'
  s.summary  = 'UIKit and Foundation tools'
  s.homepage = 'https://github.com/dvkch/SYKit'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYKit.git', :tag => s.version.to_s }
  s.source_files = '*.{h,m,c}'
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  s.resource_bundles = { 'SYSearchField' => 'Resources/loupe*.png' }
end
