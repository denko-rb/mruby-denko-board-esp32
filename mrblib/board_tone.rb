module Denko
  class Board
    # These are basically #pwm_out with added frequency parameter.
    def tone(pin, frequency, duration=nil)
      vchan = pin_to_ledc[pin] || pwm_setup(pin)
      ESP32::LEDC.timer_config(LEDC_CHANNEL_MAP[vchan][0], LEDC_CHANNEL_MAP[vchan][1], LEDC_TIMER_8_BIT, frequency)
      ESP32::LEDC.set_duty(LEDC_CHANNEL_MAP[vchan][0], LEDC_CHANNEL_MAP[vchan][2], 128)
    end
    
    def no_tone(pin)
      vchan = pin_to_ledc[pin] || pwm_setup(pin)
      ESP32::LEDC.set_duty(LEDC_CHANNEL_MAP[vchan][0], LEDC_CHANNEL_MAP[vchan][2], 128)
    end
  end
end
