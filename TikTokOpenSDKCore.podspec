#
# Copyright 2022 TikTok Pte. Ltd.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Be sure to run `pod lib lint TikTokOpenSDKCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TikTokOpenSDKCore'
  s.version          = '2.3.0'
  s.summary          = 'TikTok OpenSDK Core'
  s.description      = <<-DESC
    This is TikTok OpenSDK core, shared models and interface.
  DESC

  s.homepage         = 'https://github.com/tiktok/tiktok-opensdk-ios'
  s.license          = { :file => 'LICENSE' }
  s.author           = { 'TikTok OpenPlatform' => 'tiktok-openplatform@tiktok.com' }
  s.source           = { :git => 'https://github.com/tiktok/tiktok-opensdk-ios.git', :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '12.0'
  s.pod_target_xcconfig = {
      'GCC_PRECOMPILE_PREFIX_HEADER' => "NO",
      'DEBUG_INFORMATION_FORMAT' => "DWARF with dSYM",
      'CLANG_ENABLE_MODULES' => "YES",
      'GCC_GENERATE_DEBUGGING_SYMBOLS' => "YES"
  }
  s.default_subspecs = 'Core'
  s.frameworks = 'Foundation'
  s.swift_version = '5.0'
  s.subspec "Core" do |ss|
      ss.source_files =  'Sources/TikTokOpenSDKCore/**/*.swift'
  end

end
