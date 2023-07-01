module Denko
  class Board
    include ESP32::Constants
    CHIP_MODEL = ESP32::System.chip_model
    
    HIGH = 1
    LOW = 0
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
