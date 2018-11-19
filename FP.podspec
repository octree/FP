Pod::Spec.new do |s|
  s.name         = "FP"
  s.version      = "0.2.2"
  s.summary      = "Function Programming Utils"

  s.homepage     = "https://github.com/octree/FP"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Octree" => "octree@octree.me" }
  # s.social_media_url   = "http://twitter.com/"
  # s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.swift_version = '4.2'

  s.source       = { :git => "https://github.com/octree/FP.git", :tag => "#{s.version}" }

  s.source_files  = "Source/**/*.swift"
end