platform :ios, '9.0'

use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def addCommonDependancies
    # UI
    pod 'SDWebImage'
    pod 'KYDrawerController'
    pod 'QRCodeReader.swift'
    
    # Model
    pod 'RealmSwift'
    
    # Networking
    pod 'Alamofire'
    pod 'AlamofireObjectMapper'
    
    # Misc
    pod 'Locksmith'
    
    pod 'Fabric'
    pod 'Crashlytics'
end


target 'WorldBosses' do
    addCommonDependancies
end

addCommonDependancies

# set the pod to be not user legacy swift version
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
