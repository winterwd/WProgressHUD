#
# Be sure to run `pod lib lint WProgressHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WProgressHUD'
  s.version          = '0.1.2'
  s.summary          = 'WProgressHUD for HUD.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "view loading and customer Toast"
  s.homepage         = 'https://github.com/winterwd/WProgressHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'winter.wd' => 'winterw201501@gmail.com' }
  s.source           = { :git => 'https://github.com/winterwd/WProgressHUD.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WProgressHUD/Classes/*.{h,m}'
  
  s.resource_bundles = {
    'WProgressHUD' => ['WProgressHUD/Assets/*.png', 'WProgressHUD/Assets/*.lproj/*.strings']
  }

  s.public_header_files = 'WProgressHUD/Classes/**/*.h'
  s.dependency 'MBProgressHUD'
end
