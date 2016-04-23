Pod::Spec.new do |s|
  s.name = 'WebMock'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'HTTP stubbing for iOS and Mac OS X'
  s.homepage = 'https://github.com/wojteklu/WebMock'
  s.authors = { 'Wojtek Lukaszuk' => 'wojciech.lukaszuk@icloud.com' }
  s.source = { :git => 'https://github.com/wojteklu/WebMock.git', :tag => s.version }

  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'WebMock/*.swift'
end
