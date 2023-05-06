#
#  Be sure to run `pod spec lint ZHMacroTools,podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZHCoreModelMagic"
  s.version      = "1.0.5"
  s.summary      = "This is a tool library for binding Coredata with Model operations"
  s.description  = <<-DESC 'ZHCoreModelMagic'
                   DESC
  s.homepage     = "https://github.com/SixtyTwoPlus/ZHCoreModelMagic.git"

  s.license      = "MIT"

  s.author       = { "zhl" => "z779215878@gmail.com" }

  s.platform     = :ios

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/SixtyTwoPlus/ZHCoreModelMagic.git", :tag => "v#{s.version}" }

  s.source_files = 'ZHCoreModelMagic/*'

  s.libraries    = 'objc'
	
  s.frameworks   = 'Foundation'

  s.requires_arc = true

  s.dependency 'MagicalRecord'

  s.dependency 'YYCache'

  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/Headers/Public/MagicalRecord' }

end
