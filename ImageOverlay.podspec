Pod::Spec.new do |spec|
  spec.name         = 'ImageOverlay'
  spec.version      = '0.2.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/toshi0383/ImageOverlay'
  spec.authors      = { 'Toshihiro Suzuki' => 't.suzuki326@gmail.com' }
  spec.summary      = 'UIImageView.overlayContentView made easy and even cooler on tvOS'
  spec.source       = { :git => 'https://github.com/nahrwl/ImageOverlay.git', :tag => '0.2.1' }
  spec.source_files = 'ImageOverlay/**/*.{swift,m,h}'
end
