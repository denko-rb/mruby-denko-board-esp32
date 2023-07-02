module Denko
  class Board
    # These are basically #pwm_out with added frequency parameter.
    # Two sequentially added buzzers will fight over the same timer. Reserve two channels instead?
    def tone(pin, frequency, duration=nil)
      vchan = @pin_to_ledc[pin] || ledc_setup(pin)
      ledc_set_freq(LEDC_MAP[vchan][0], LEDC_MAP[vchan][1], frequency)
      ledc_set_duty(LEDC_MAP[vchan][0], LEDC_MAP[vchan][2], 128)
    end
    
    def no_tone(pin)
      vchan = @pin_to_ledc[pin] || ledc_setup(pin)
      ledc_set_duty(LEDC_MAP[vchan][0], LEDC_MAP[vchan][2], 0)
    end
  end
end
