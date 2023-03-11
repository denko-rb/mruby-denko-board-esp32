require_relative "mrblib/version"

MRuby::Gem::Specification.new('mruby-dino-sys-esp32') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.version = Dino::ESP32::VERSION
  
  # Dependencies from mruby-esp32 project.
  spec.add_dependency('mruby-esp32-system', github: 'dino-rb/mruby-esp32-system')
  spec.add_dependency('mruby-esp32-gpio',   github: 'dino-rb/mruby-esp32-gpio')
  spec.add_dependency('mruby-io',           github: 'mruby-esp32/mruby-io', :branch => 'esp32')
  
  # Include files in the right order.
  spec.rbfiles = [
    "#{dir}/mrblib/version.rb",
    "#{dir}/mrblib/system.rb",
    "#{dir}/mrblib/board.rb",
  ]
end