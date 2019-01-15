#
#  Be sure to run `pod spec lint BDTools.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "BDTools"
    s.version      = "0.0.1"
    s.ios.deployment_target = '7.0'
    s.summary      = "BDTools是一个工具类"
    s.homepage     = "https://github.com/ParfumeFlottor/BDTools.git"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "fengyesha" => "1724478441@qq.com" }
    s.social_media_url   = "https://weibo.com/3265673473/profile?topnav=1&wvr=6"
    s.source       = { :git => "https://github.com/ParfumeFlottor/BDTools.git", :tag => s.version }
    s.source_files  = "BDTools/BDTools/Tools/*.{h,m}" 
    s.requires_arc = true
end

