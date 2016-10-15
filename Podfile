source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'nava' do
pod 'Alamofire', '~> 4.0'
pod 'AlamofireImage', '~> 3.1'
pod 'RAMAnimatedTabBarController'
pod 'SlideMenuControllerSwift'
pod 'SwiftyJSON'
pod 'XLPagerTabStrip', :git => 'https://github.com/KelvinJin/XLPagerTabStrip', :branch => 'swift3'
pod 'Jukebox', '~> 0.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
