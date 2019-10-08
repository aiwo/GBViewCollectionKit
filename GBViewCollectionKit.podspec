Pod::Spec.new do |s|
  s.name             = 'GBViewCollectionKit'
  s.version          = '0.2.10'
  s.summary          = 'Model based configuration of collection views.'

  s.description      = <<-DESC
Library that implements MVVM (Model View ViewModel)-Pattern for Table/Collection-Views. Based on work of Kristaps Zeibarts.
                       DESC

  s.homepage         = 'https://github.com/aiwo/GBViewCollectionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gennady Berezovsky' => 'bergencroc@gmail.com' }
  s.source           = { :git => 'https://github.com/aiwo/GBViewCollectionKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'

  s.source_files = 'GBViewCollectionKit/Classes/**/*'
  s.resource_bundles = {
      'GBViewCollectionKitResources' => [
        'GBViewCollectionKit/Classes/**/*.xib'
      ]
  }

end
