#
#  Be sure to run `pod spec lint YRBaseHubOC.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YRBaseHubOC"      #名称
  s.version      = "0.0.4"	      #版本号
  s.summary      = "iOS OC项目基础模块"  #简短介绍，下面description是详细介绍

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                   iOS OC项目基础模块仓库
                   DESC

  s.homepage     = "https://github.com/chanyarin/YRBaseHubOC"	#主页，这里要填写可以访问到的地址，不然验证不通过
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"	#截图


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"	#开源协议
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "chanyarin" => "chanyarin@163.com" }	#作者信息
  # Or just: s.author    = "chanyarin"
  # s.authors            = { "chanyarin" => "chanyarin@163.com" }
  # s.social_media_url   = "http://twitter.com/chanyarin"	#多媒体介绍地址

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"	#支持的平台及版本

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/chanyarin/YRBaseHubOC.git", :tag => "#{s.version}" }	#项目地址，这里不支持ssh的地址，验证不通过，只支持HTTP和HTTPS，最好使用HTTPS


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

s.source_files  = "YRBaseHubOC/YRBaseHubOC.h"	#代码源文件地址

s.subspec 'Category' do |cas|
   cas.source_files = 'YRBaseHubOC/Category/**/*.{h,m}'
   #cas.public_header_files = "YRBaseHubOC/Category/Category.h"
end

s.subspec 'Const' do |cos|
   cos.source_files = 'YRBaseHubOC/Const/*.h'
   #cos.public_header_files = "YRBaseHubOC/Const/Const.h"
end

s.subspec 'Enum' do |ens|
   ens.source_files = 'YRBaseHubOC/Enum/*.h'
   #ens.public_header_files = "YRBaseHubOC/Enum/Enum.h"
end

s.subspec 'Macro' do |mas|
   mas.source_files = 'YRBaseHubOC/Macro/*.h'
   #mas.public_header_files = "YRBaseHubOC/Macro/Macro.h"
end

s.subspec 'Util' do |uts|
   uts.source_files = 'YRBaseHubOC/Util/*.{h,m}'
   #uts.public_header_files = "YRBaseHubOC/Util/Util.h"
end

s.subspec 'KVO' do |kvos|
   kvos.source_files = 'YRBaseHubOC/KVO/*.{h,m}'
   #uts.public_header_files = "YRBaseHubOC/KVO/KeyValueObserver.h"
end

  # s.public_header_files = "Classes/**/*.h"	#公开头文件地址


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
s.frameworks = "UIKit", "Foundation"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
