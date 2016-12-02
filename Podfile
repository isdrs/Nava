source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'nava' do
pod 'Alamofire', '~> 4.0'
pod 'AlamofireImage', '~> 3.1'
pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
pod 'RAMAnimatedTabBarController'
pod 'SwiftyJSON'
pod 'XLPagerTabStrip', :git => 'https://github.com/KelvinJin/XLPagerTabStrip', :branch => 'swift3'
pod 'Jukebox', '~> 0.2.0'
pod 'SCLAlertView'
pod 'GRDB.swift'
pod 'Firebase'
pod 'FirebaseMessaging'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
