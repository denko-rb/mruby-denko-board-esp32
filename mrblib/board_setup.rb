module Denko
  class Board
    include ESP32::Constants
    CHIP_MODEL = ESP32::System.chip_model
    
    HIGH = 1
    LOW = 0
    
    def low
      LOW
    end
    
    def high
      HIGH
    end
    
    def pwm_high
      255
    end
    
    def adc_high
      4095
    end
    
    def dac_high
      255
    end    
  end
end
