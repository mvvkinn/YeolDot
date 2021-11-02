Pod::Spec.new do |s|
  s.name        = "CocoaMQTT"
  s.version     = "1.2.1"
  s.summary     = "MQTT v3.1.1 client library for iOS and OS X written with Swift 5"
  s.homepage    = "https://github.com/emqtt/CocoaMQTT"
  s.license     = { :type => "MIT" }
  s.authors     = { "Feng Lee" => "feng@emqtt.io", "CrazyWisdom" => "zh.whong@gmail.com", "Alex Yu" => "alexyu.dc@gmail.com" }

  s.swift_version = "5.0"
  s.requires_arc = true
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  # s.watchos.deployment_target = "2.0"
  s.source   = { :git => "https://github.com/emqtt/CocoaMQTT.git", :tag => "1.2.1"}
  s.source_files = "Source/{*.h}", "Source/*.swift"
  s.dependency "CocoaAsyncSocket", "~> 7.6.3"
end
