Pod::Spec.new do |spec|
  spec.name             = 'SCLTAudioPlayer'
  spec.version          = '1.0.0'
  spec.license          = '' 
  spec.homepage         = 'https://github.com/scarlet/SCLTAudioPlayer'
  spec.authors          = { 'Scarlet' => 'support@scarlet.io' }
  spec.summary          = 'An audio player with background task support'
  spec.source           = { :git => 'https://github.com/scarlet/SCLTAudioPlayer.git', :branch => 'master' }
  spec.source_files     = 'SCLTAudioPlayer/*'
  spec.framework        = 'AVFoundation'
  spec.requires_arc     = true
end