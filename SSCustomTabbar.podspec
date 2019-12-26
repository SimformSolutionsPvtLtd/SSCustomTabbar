#
# Be sure to run `pod lib lint SSCustomTabbar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                  = 'SSCustomTabbar'
    s.version               = '2.0.3'
    s.platform              = :ios
    s.swift_version         = '5.0'
    s.summary               = 'Simple Animated tabbar with native control.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/simformsolutions/SSCustomTabbar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sumit Goswami' => 'sumit.g@simformsolutions.com' }
  s.source           = { :git => 'https://github.com/simformsolutions/SSCustomTabbar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

s.source       = { :git => "https://github.com/simformsolutions/SSCustomTabbar.git",:tag => s.version }
s.source_files  = 'SSCustomTabbar/Classes/*.swift'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end