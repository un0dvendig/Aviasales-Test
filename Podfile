source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'

inhibit_all_warnings!

target 'Aviasales Test' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aviasales Test
  pod 'Alamofire'
  pod 'TinyConstraints'
  pod 'Moya', '~> 14.0'
  pod 'SwiftRichString'
  pod 'SHSearchBar'
  pod 'SVProgressHUD' 
  pod 'Swinject'
  pod 'SwinjectAutoregistration', '~> 2.7.0'
  pod 'DifferenceKit/Core'
  pod 'DifferenceKit/UIKitExtension'
end

# Workaround to silence warnings in Xcode 12+
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('12.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end