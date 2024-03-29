# mruby-denko-board-esp32

This gem aims to implement `Denko::Board`, with a similar interface to the [denko CRuby gem](https://github.com/denko-rb/denko). It allows `Denko` peripheral classes to be used on mruby, self-contained on the ESP32 microcontroller. This is a work-in-progress.

## Usage

The eventual plan is to make pre-compiled binaries available for each board or chip. They would implement USB Mass Storage where avialable, and run `main.rb` from the root directory on boot.

Right now though, it must be run by compiling the entire ESP-IDF project and flashing the board, which will run `main.rb` from the `main/spiffs` folder.

[mruby-denko](https://github.com/denko-rb/mruby-denko) contains ready-to-use ESP-IDF project folders for the different chips.

## Features

### Already Implemented
  - Serial Logging (`puts` writes to Serial interface)
  - Internal Pull Down/Up Resistors
  - Open Drain Mode
  - Digital Input (no automatic listeners like main gem)
  - Digital Output
  - PWM Output (all LEDC channels)
  - Tone Out
  - Analog Input (all ADC1 channels, no ADC2 yet)
  - Analog Output (only original ESP32 and S2 have DACs)

### Known Issues
  - Buzzer will change the PWM frequency of any device it happens to share a LEDC timer with.
  - Likewise, servos probably shouldn't share timers with other devices.
  - LEDs automatically tie up a LEDC channel even if being used as digital.

### To Be Implemented
  - WiFi
  - USB Mass Storage
  - Servo
  - OneWire
  - DHT Class Temperature + Humidity Sensors
  - I2C
  - SPI
  - Infrared Out
  - Hardware UART
  - BitBang I2C
  - BitBang SPI 
  - BitBang UART
  - WS2812

## Dependencies
mruby fork (branch 'esp32-stable') with some modifications for ESP32:

- [mruby](https://github.com/denko-rb/mruby)

These gems (forked from [mruby-esp32](https://github.com/mruby-esp32)) are submodules in this repo, but mapped to different mruby methods:

- [mruby-esp32-system](https://github.com/denko-rb/mruby-esp32-system)
- [mruby-esp32-gpio](https://github.com/denko-rb/mruby-esp32-gpio)
- [mruby-esp32-ledc](https://github.com/denko-rb/mruby-esp32-ledc)
