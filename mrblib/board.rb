class Board
  include ESP32::Constants
  include ESP32::GPIO

  attr_accessor :ledc_pins
  
  def initialize
    @ledc_pins = Array.new(16)
  end

  def pin_mode(gpio, mode)
    case mode
    when :input_pullup;   ESP32::GPIO.pin_mode(gpio, ESP32::GPIO_MODE_INPUT_PULLUP)
    when :input_pulldown; ESP32::GPIO.pin_mode(gpio, ESP32::GPIO_MODE_INPUT_PULLDOWN)
    when :input;          ESP32::GPIO.pin_mode(gpio, ESP32::GPIO_MODE_INPUT)
    when :output;         ESP32::GPIO.pin_mode(gpio, ESP32::GPIO_MODE_OUTPUT)
    when :input_output;   ESP32::GPIO.pin_mode(gpio, ESP32::GPIO_MODE_INPUT_OUTPUT)  
    else raise "invalid mode given: #{mode}"
    end
  end
  
  def digital_write(pin, value)
    ESP32::GPIO.digital_write(pin, value)
  end
  
  def digital_read(pin)
    ESP32::GPIO.digital_read(pin)
  end
  
  def dac_write(dac_channel, value)
    ESP32::GPIO.analog_write(dac_channel, value)
  end
  
  def ledc_assign(pin)
    (0..ledc_pins.length - 1).each do |index|
      if ledc_pins[index] == pin
        # Pin already assigned to this channel.
        return index
      elsif !ledc_pins[index]
        # Channel unassigned. Use it.
        ledc_pins[index] = pin
        return index
      end
    end
    nil
  end
    
  def ledc_detach(pin)
    ESP32::LEDC.deatch(pin)
    (0..ledc_pins.length - 1).each do |index|
      ledc_pins[index] = nil if ledc_pins[index] == pin
    end
  end
  
  def pwm_setup(pin)
    vchan = ledc_assign(pin)
    group = LEDC_CHANNEL_MAP[vchan][0]
    timer = LEDC_CHANNEL_MAP[vchan][1]
    channel = LEDC_CHANNEL_MAP[vchan][2]
    # Just Arduino defaults for now
    resolution = LEDC_TIMER_8_BIT
    frequency = 1000
    
    ESP32::LEDC.timer_config(group, timer, resolution, frequency)
    ESP32::LEDC.channel_config(pin, group, timer, channel)
    
    # Component stores virtual channel.
    vchan
  end

  def pwm_write(vchan, value)
    ESP32::LEDC.write(LEDC_CHANNEL_MAP[vchan][0], LEDC_CHANNEL_MAP[vchan][2], value)
  end
  
  def adc_read(adc_channel)
    ESP32::GPIO.analog_read(adc_channel)
  end
  
  # Treat the LEDC channel groups as a continuous set of 16.
  # Share the timers the same way Arduino dies.
  LEDC_CHANNEL_MAP = [
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_0],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_1],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_2],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_3],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_4],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_5],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_6],
    [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_7],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_0],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_1],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_2],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_3],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_4],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_5],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_6],
    [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_7],
  ]
  
  # GPIO map for the original ESP32.
  # Need to change this depending on which variant is being used.
  GPIO_MAP = [
    GPIO_NUM_0,
    GPIO_NUM_1,
    GPIO_NUM_2,
    GPIO_NUM_3,
    GPIO_NUM_4,
    GPIO_NUM_5,
    GPIO_NUM_6,
    GPIO_NUM_7,
    GPIO_NUM_8,
    GPIO_NUM_9,
    GPIO_NUM_10,
    GPIO_NUM_11,
    GPIO_NUM_12,
    GPIO_NUM_13,
    GPIO_NUM_14,
    GPIO_NUM_15,
    GPIO_NUM_16,
    GPIO_NUM_17,
    GPIO_NUM_18,
    GPIO_NUM_19,
    nil,
    GPIO_NUM_21,
    GPIO_NUM_22,
    GPIO_NUM_23,
    nil,
    GPIO_NUM_25,
    GPIO_NUM_26,
    GPIO_NUM_27,
    nil,
    nil,
    nil,
    nil,
    GPIO_NUM_32,
    GPIO_NUM_33,
    GPIO_NUM_34,
    GPIO_NUM_35,
    GPIO_NUM_36,
    GPIO_NUM_37,
    GPIO_NUM_38,
    GPIO_NUM_39,
  ]
  
  ADC1_MAP = {
    36 => ADC_CHANNEL_0,
    37 => ADC_CHANNEL_1,
    38 => ADC_CHANNEL_2,
    39 => ADC_CHANNEL_3,
    32 => ADC_CHANNEL_4,
    33 => ADC_CHANNEL_5,
    34 => ADC_CHANNEL_6,
    35 => ADC_CHANNEL_7,
  }
  
  DAC_MAP = {
    25 => DAC_CHAN_0,
    26 => DAC_CHAN_1,
  }
  
  def map_pin(number)
    GPIO_MAP[number]
  end
  
  def map_adc(number)
    ADC1_MAP[number]
  end
  
  def map_dac(number)
    DAC_MAP[number]
  end
end

$board = Board.new