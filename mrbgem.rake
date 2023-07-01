require_relative "mrblib/version"

MRuby::Gem::Specification.new('mruby-denko-board-esp32') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.version = Denko::Board::VERSION
  
  # Forked dependencies from mruby-esp32 project.
  spec.add_dependency('mruby-esp32-system', github: 'denko-rb/mruby-esp32-system')
  spec.add_dependency('mruby-esp32-gpio',   github: 'denko-rb/mruby-esp32-gpio')
  spec.add_dependency('mruby-esp32-ledc',   github: 'denko-rb/mruby-esp32-ledc')
  
  # Direct dependencies from mruby-esp32 project.
  spec.add_dependency('mruby-io',           github: 'mruby-esp32/mruby-io', :branch => 'esp32')
  
  # Include files in the right order.
  spec.rbfiles = [
    "#{dir}/mrblib/version.rb",
    "#{dir}/mrblib/system.rb",
    "#{dir}/mrblib/board_setup.rb",
    "#{dir}/mrblib/board_gpio.rb",
    "#{dir}/mrblib/board_pwm.rb",
    "#{dir}/mrblib/board_tone.rb",
    "#{dir}/mrblib/board_adc.rb",
    "#{dir}/mrblib/board_dac.rb",
    "#{dir}/mrblib/board.rb",
  ]
end
