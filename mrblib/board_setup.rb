module Denko
  class Board
    include ESP32::Constants
    CHIP_MODEL = self.chip_model
    
    # LOW and HIGH defined in C.
    PWM_HIGH = 255
    ADC_HIGH = 4095
    DAC_HIGH = 255
    
    def low
      LOW
    end
    
    def high
      HIGH
    end
    
    def pwm_high
      PWM_HIGH
    end
    
    def adc_high
      ADC_HIGH
    end
    
    def dac_high
      DAC_HIGH
    end    
  end
end
