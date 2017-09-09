source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'SwiftLint', '~> 0.16'
  pod 'BaseX', :git => 'https://github.com/Sajjon/SwiftBaseX.git'
  pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift.git', :branch => 'swift4'
end

target 'NeoSwift' do
	pods  
end

target 'NeoSwiftTests' do
	pods  
end
