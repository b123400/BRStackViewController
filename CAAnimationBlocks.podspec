Pod::Spec.new do |s|
  s.platform = :ios
  s.name           = 'caanimationblock'
  s.license        = 'MIT'
  s.author    = { 'xissburg' => 'xissburg@gmail.com' }
  s.version        = '0.0.1'
  s.source         = { :git => 'git://github.com/xissburg/CAAnimationBlocks.git', :commit => '38248ddf675a22f7f73291a0c39b65efc1816116' }

  s.source_files   = 'CAAnimationBlocks/CAAnimation+Blocks.h','CAAnimationBlocks/CAAnimation+Blocks.m'

  s.frameworks = 'QuartzCore'
end