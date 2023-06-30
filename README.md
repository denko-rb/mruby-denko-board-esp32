# mruby-denko-board-esp32

This gem aims to implement `Denko::Board`, similar in interface to the [denko CRuby gem](https://github.com/denko-rb/denko). It allows `Denko` peripheral classes to be used on mruby, self-contained on the ESP32 microcontroller. This is a work-in-progress.

## Usage

The eventual plan is to make pre-compiled binaries available for each board or chip. They would implement USB Mass Storage where avialable, and run `main.rb` from the root directory on boot.

Right now though, it must be run by compiling the entire ESP-IDF project and uploading to the board, with `main.rb` in the `spiffs` folder. See [mruby-denko](https://github.com/denko-rb/mruby-denko) for project templates.

## Supported Hardware

|    Chip        | Build Status    | Board Tested         | Notes |
| :--------      | :------:        | :---------------     |------ |
| ESP32          | :green_heart:   | DOIT ESP32 DevKit V1 |
| ESP32-S2       | :heart:         | LOLIN S2 Pico        | Native USB
| ESP32-S3       | :green_heart:   | LOLIN S3 V1.0.0      | Native USB
| ESP32-C3       | :heart:         | LOLIN C3 Mini V2.1.0 | Native USB
| ESP32-C2       | :question:      | -                    | 
| ESP32-C6       | :question:      | -                    | 
| ESP32-H2       | :question:      | -                    | 

## Features

### Already Implemented
  - Serial Logging (`puts` writes to Serial interface)
  - Internal Pull Down/Up Resistors
  - Open Drain Mode
  - Digital Input (no automatic listeners like main gem)
  - Digital Output
  - PWM Output (all LEDC channels)
  - Analog Input (all ADC1 channels, no ADC2 yet)
  - Analog Output (only original ESP32 and S2 have DACs)

### To Be Implemented
  - WiFi
  - USB Mass Storage
  - Servo
  - OneWire
  - DHT Class Temperature + Humidity Sensors
  - I2C
  - SPI
  - Tone Out
  - Infrared Out
  - Hardware UART
  - BitBang I2C
  - BitBang SPI 
  - BitBang UART
  - WS2812

## Dependencies
- [mruby-esp32-system](https://github.com/denko-rb/mruby-esp32-system)
- [mruby-esp32-gpio](https://github.com/denko-rb/mruby-esp32-gpio)
- [mruby-esp32-ledc](https://github.com/denko-rb/mruby-esp32-ledc)

These are forked from [mruby-esp32](https://github.com/mruby-esp32).
