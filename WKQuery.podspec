Pod::Spec.new do |s|
  s.name             = "WKQuery"
  s.version          = "1.0.0"
  s.summary          = "A lib used on iOS."
  s.description      = <<-DESC
                       It is a lib used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/ZhangDo/WKQuery"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "walker" => "dark_horse8023@163.com" }
  s.source           = { :git => "https://github.com/ZhangDo/WKQuery.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'
 
  #s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true
 
  s.source_files = 'WKQuery/*'
  # s.resources = 'Assets'
 
  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
 
end
