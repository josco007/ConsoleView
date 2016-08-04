#
# Be sure to run `pod lib lint ConsoleView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConsoleView'
  s.version          = '0.1.0'
  s.summary          = 'This utility is capable to display the debug in a floating view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: I make this utiity because in some of my applications I utilize a scanner device (Honywell captuvo) and with that scanner is not possible connect my device to the computer thus I couldn´t debug my application.
                       DESC

  s.homepage         = 'https://github.com/josco007/ConsoleView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'josco007' => 'noe_is10@msn.com' }
  s.source           = { :git => 'https://github.com/josco007/ConsoleView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ConsoleView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ConsoleView' => ['ConsoleView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
