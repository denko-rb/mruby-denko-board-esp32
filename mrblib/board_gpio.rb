module Denko
  class Board
    #
    # Build array of the available GPIO by checking for GPIO_NUM_* constants.
    # Varies by chip. Value is GPIO integer where available, nil otherwise.
    #
    gpio_map_temp = []
    (0..48).each do |i|
      if ESP32::Constants.const_defined?("GPIO_NUM_#{i}")
        gpio_map_temp[i] = ESP32::Constants.const_get("GPIO_NUM_#{i}")
      else
        gpio_map_temp[i] = nil
      end
    end
    GPIO_MAP = gpio_map_temp.dup
  
    def convert_pin(number)
      pin = GPIO_MAP[number]
      if !pin
        raise "given pin: #{number} is unavailable"
      else
        return pin
      end
    end

    def set_pin_mode(gpio, mode)
      mode_def = nil
      case mode
      when :input;                    mode_def = ESP32::GPIO_MODE_INPUT
      when :output;                   mode_def = ESP32::GPIO_MODE_OUTPUT
      when :input_pullup;             mode_def = ESP32::GPIO_MODE_INPUT_PULLUP
      when :input_pulldown;           mode_def = ESP32::GPIO_MODE_INPUT_PULLDOWN 
      when :input_pullup_pulldown;    mode_def = ESP32::GPIO_MODE_INPUT_PULLUP_PULLDOWN
      when :input_output;             mode_def = ESP32::GPIO_MODE_INPUT_OUTPUT
      when :input_output_open_drain;  mode_def = ESP32::GPIO_MODE_INPUT_OUTPUT_OD
      when :output_open_drain;        mode_def = ESP32::GPIO_MODE_OUTPUT_OD
      else raise "unknown pin mode given: #{mode}"
      end
      ESP32::GPIO.pin_mode(gpio, mode_def) if mode_def
    end
  
    def digital_write(pin, value)
      ESP32::GPIO.digital_write(pin, value)
    end
  
    def digital_read(pin)
      ESP32::GPIO.digital_read(pin)
    end
  end
end
