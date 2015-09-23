use_frameworks!

def common_pods
    pod 'SQLite.swift', git: 'https://github.com/stephencelis/SQLite.swift.git', :branch => 'swift-2'
    pod 'CryptoSwift', '0.0.14'
end

target :FledgerCommon do
    platform :ios, '8.4'
    #pod 'Parse', '1.8.0'
    common_pods
end

target :FledgerCommonMac do
    platform :osx, '10.10'
    pod 'Parse-OSX', '1.8.0'
    common_pods
end
