platform :ios, '9.0'

use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def addCommonDependancies
    # UI
    pod 'SDWebImage'
    pod 'KYDrawerController'
    pod 'QRCodeReader.swift'
    pod 'RZTransitions', :git => 'https://github.com/austinzmchen/RZTransitions.git', :branch => 'release/ACCustomUI_1.1.4'
    pod 'ACKit', :git => 'https://github.com/austinzmchen/ACKit.git', :branch => 'master'
    
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
