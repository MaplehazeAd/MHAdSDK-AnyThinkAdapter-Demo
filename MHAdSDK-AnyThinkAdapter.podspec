Pod::Spec.new do |s|
  s.name         = 'MHAdSDK-AnyThinkAdapter'
  s.version      = '1.0.0'
  s.summary      = 'TopOn (Taku/AnyThink) custom adapter for MHAdSDK.'
  s.description  = <<-DESC
    MHAdSDK-TopOnAdapter is a custom network adapter for MHAdSDK on the TopOn mediation platform.
    Supports Splash, Native, and RewardedVideo ad formats.
  DESC

  s.homepage     = 'https://github.com/MaplehazeAd/MHAdSDK-AnyThinkAdapter-Demo'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'MaplehazeAd' => 'rd@maplehaze.cn' }

  s.source       = { :git => 'https://github.com/MaplehazeAd/MHAdSDK-TopOnAdapter-Demo.git', :tag => s.version.to_s }

  s.platform     = :ios, '13.0'
  s.requires_arc = true
  s.static_framework = true

  s.source_files = 'MHAdSDK-AnyThinkAdapter/**/*.{h,m}'
  s.public_header_files = 'MHAdSDK-AnyThinkAdapter/**/*.h'

  s.dependency 'MHAdSDK', '~> 1.4.6'
  s.dependency 'AnyThinkiOS', '~> 6.5.80'

  s.frameworks   = 'UIKit', 'Foundation'
end
