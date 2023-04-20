#
#  Be sure to run `pod spec lint ZHMacroTools,podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZHCategory"
  s.version      = "1.0.1"
  s.summary      = "this is iOS common category tools"
  s.description  = <<-DESC 'ZHCategory'
                   DESC
  s.homepage     = "https://github.com/SixtyTwoPlus/ZHCategory.git"

  s.license      = "MIT"

  s.author       = { "zhl" => "z779215878@gmail.com" }

  s.platform     = :ios

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/SixtyTwoPlus/ZHCategory.git", :tag => "v#{s.version}" }

  s.source_files = 'ZHCategory/*'

  s.frameworks   = 'Foundation', 'UIKit'

  s.requires_arc = true

end
