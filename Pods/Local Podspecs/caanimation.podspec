Pod::Spec.new do |s|
  s.platform = :ios
  s.name           = 'caanimation'
  s.license        = 'MIT'
  s.author    = { 'XXX' => 'yyy@zzz.com' }
  s.version        = '0.0.1'
  s.source         = { :git => 'git://github.com/xissburg/CAAnimationBlocks.git', :commit => '38248ddf675a22f7f73291a0c39b65efc1816116' }
  s.source_files   = 'CAAnimationBlocks/*.{h,m}'
end
