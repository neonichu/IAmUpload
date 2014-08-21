Pod::Spec.new do |s|
  s.name             = "IAmUpload"
  s.version          = "0.1.0"
  s.summary          = "Objective-C library for using the Uploads.im API."
  s.homepage         = "https://github.com/neonichu/IAmUpload"
  s.license          = 'MIT'
  s.author           = { "Boris Bügling" => "boris@icculus.org" }
  s.source           = { :git => "https://github.com/neonichu/IAmUpload.git", 
                         :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NeoNacho'

  s.ios.deployment_target     = '6.0'
  s.osx.deployment_target     = '10.8'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'AFNetworking', '~> 2.3'
end
