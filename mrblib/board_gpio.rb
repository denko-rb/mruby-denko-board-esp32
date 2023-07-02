module Denko
  class Board
    #
    # Build array of the available GPIO by checking for GPIO_NUM_* constants.
    # Varies by chip. Value is GPIO integer where available, nil otherwise.
    #
    gpio_map_temp = []
    (0..48).each do |i|
      if self.const_defined?("GPIO_NUM_#{i}")
        gpio_map_temp[i] = self.const_get("GPIO_NUM_#{i}")
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

    def set_pin_mode(pin, mode)
      # LEDC detach here?
      case mode
      when :input;                    mode_const = GPIO_MODE_INPUT
      when :output;                   mode_const = GPIO_MODE_OUTPUT
      when :input_pullup;             mode_const = GPIO_MODE_INPUT_PULLUP
      when :input_pulldown;           mode_const = GPIO_MODE_INPUT_PULLDOWN 
      when :input_pullup_pulldown;    mode_const = GPIO_MODE_INPUT_PULLUP_PULLDOWN
      when :input_output;             mode_const = GPIO_MODE_INPUT_OUTPUT
      when :input_output_open_drain;  mode_const = GPIO_MODE_INPUT_OUTPUT_OD
      when :output_open_drain;        mode_const = GPIO_MODE_OUTPUT_OD
      else raise "unknown pin mode given: #{mode}"
      end
      # Defined in C.
      gpio_set_direction(pin, mode_const)
    end
  
    # digital_write defined purely in C.
    # digital_read  defined purely in C.
  end
end
