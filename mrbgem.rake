require_relative "mrblib/version"

MRuby::Gem::Specification.new('mruby-denko-board-esp32') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.version = Denko::Board::VERSION
  
  # This was a modified io gem by mruby-esp32.
  # Replaced by core gem from mruby fork at: https://github.com/denko-rb/mruby
  # spec.add_dependency('mruby-io', github: 'mruby-esp32/mruby-io', :branch => 'esp32')

  # Use these as submodules inside ./ext, since only using parts of their C files.
  # spec.add_dependency('mruby-esp32-system', github: 'denko-rb/mruby-esp32-system')
  # spec.add_dependency('mruby-esp32-gpio',   github: 'denko-rb/mruby-esp32-gpio')
  # spec.add_dependency('mruby-esp32-ledc',   github: 'denko-rb/mruby-esp32-ledc')
  
  # Custom method mapping, separate from mruby-esp32.
  # src/mrb_denko_board_esp32.c is automatically incldued in compiler path.
  
  # Need to make some things conditional for ESP32 variants in future.
  if spec.cc.defines.include?("ESP_PLATFORM")
  end
  
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
