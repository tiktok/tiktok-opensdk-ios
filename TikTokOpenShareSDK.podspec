#
# Copyright 2022 TikTok Pte. Ltd.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Be sure to run `pod lib lint TikTokOpenShareSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TikTokOpenShareSDK'
  s.version          = '2.2.0'
  s.summary          = 'TikTok OpenSDK Share'
  s.description      = <<-DESC
    This is TikTok OpenSDK for video and image sharing.
  DESC

  s.homepage         = 'https://github.com/tiktok/tiktok-opensdk-ios'
  s.license          = { :file => 'LICENSE' }
  s.author           = { 'TikTok OpenPlatform' => 'tiktok-openplatform@tiktok.com' }
  s.source           = { :git => 'https://github.com/tiktok/tiktok-opensdk-ios.git', :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig = {
      'GCC_PRECOMPILE_PREFIX_HEADER' => "NO",
      'DEBUG_INFORMATION_FORMAT' => "DWARF with dSYM",
      'CLANG_ENABLE_MODULES' => "YES",
      'GCC_GENERATE_DEBUGGING_SYMBOLS' => "YES"
  }

  s.default_subspecs = 'Share'
  s.frameworks = 'UIKit', 'Foundation'
  s.swift_version = '5.0'
  s.dependency 'TikTokOpenSDKCore', "#{s.version}"

  s.subspec "Share" do |ss|
      ss.source_files =  'Sources/TikTokOpenShareSDK/**/*.swift'
  end

  s.test_spec 'UnitTests' do |ts|
    ts.requires_app_host = true
    ts.source_files = 'Tests/TikTokOpenShareSDKTests/**/*.swift'
  end

end
