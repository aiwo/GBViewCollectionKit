Pod::Spec.new do |s|
  s.name             = 'GBViewCollectionKit'
  s.version          = '0.0.3'
  s.summary          = 'Model based configuration of collection views.'

  s.description      = <<-DESC
Library that implements MVVM (Model View ViewModel)-Pattern for Table/Collection-Views. Based on work of Kristaps Zeibarts.
                       DESC

  s.homepage         = 'https://bitbucket.org/aiwo/GBViewCollectionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gennady Berezovsky' => 'gennady.berezovsky@gmail.com' }
  s.source           = { :git => 'git@bitbucket.org:aiwo/GBViewCollectionKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'GBViewCollectionKit/Classes/**/*'

end
