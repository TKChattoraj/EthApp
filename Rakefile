# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'
require 'motion/project'
require 'rubygems'
require 'motion-cocoapods'


begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'EthApp'

  app.info_plist['CFBundleIconName'] = 'AppIcon'

  app.info_plist['NSAppTransportSecurity'] = {'NSAllowsArbitraryLoads' => true}
  app.detect_dependencies = true

  app.pods do
    pod 'AFNetworking'
    pod 'OpenSSL-Universal'
  end
end
