#
# Be sure to run `pod lib lint WProgressHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WProgressHUD'
  s.version          = '0.1.0'
  s.summary          = 'WProgressHUD for HUD.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://www.jianshu.com/u/06f42a993882'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'winter.wd' => 'winterw201501@gmail.com' }
  s.source           = { :git => 'https://git.thy360.com/ios-compose/jh_hud.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WProgressHUD/Classes/**/*'
  
  s.resource_bundles = {
    'WProgressHUD' => ['WProgressHUD/Assets/*.png']
  }

  s.public_header_files = 'WProgressHUD/Classes/**/*.h'
  s.dependency 'MBProgressHUD', '~>1.0'
end
