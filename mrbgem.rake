require_relative "mrblib/version"

MRuby::Gem::Specification.new('mruby-denko-board-esp32') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.version = Denko::Board::VERSION
  
  # Direct dependencies from mruby-esp32 project.
  # Replaced this by requiring standard 'mruby-io' in mruby-denko-core,
  # and using a forked version of mruby, specifically for ESP32.
  # spec.add_dependency('mruby-io',           github: 'mruby-esp32/mruby-io', :branch => 'esp32')
  
  # These gems have their partial source included, with a custom initializer
  # for better performance:
  #
  # spec.add_dependency('mruby-esp32-system', github: 'denko-rb/mruby-esp32-system')
  # spec.add_dependency('mruby-esp32-gpio',   github: 'denko-rb/mruby-esp32-gpio')
  # spec.add_dependency('mruby-esp32-ledc',   github: 'denko-rb/mruby-esp32-ledc')
  
  # src/mrb_denko_board_esp32.c is automatically incldued in compiler path.
  
  # Include files in the right order.
  spec.rbfiles = [
    "#{dir}/mrblib/version.rb",
    "#{dir}/mrblib/board_setup.rb",
    "#{dir}/mrblib/board_gpio.rb",
    "#{dir}/mrblib/board_pwm.rb",
    "#{dir}/mrblib/board_tone.rb",
    "#{dir}/mrblib/board_adc.rb",
    "#{dir}/mrblib/board_dac.rb",
    "#{dir}/mrblib/board.rb",
  ]
end
