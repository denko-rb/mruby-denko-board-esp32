module Denko
  class Board
    #
    # DAC is available only on original ESP32 and S2.
    if SOC_DAC_SUPPORTED
      #
      # Hash that maps GPIO to their connected DAC channels, depending on chip model.
      if (CHIP_MODEL == CHIP_ESP32)
        DAC_MAP = {
          25 => DAC_CHAN_0,
          26 => DAC_CHAN_1,
        }
      elsif (CHIP_MODEL == CHIP_ESP32S2)
        DAC_MAP = {
          17 => DAC_CHAN_0,
          18 => DAC_CHAN_1,
        }
      else
        DAC_MAP = {}
      end
    
      def map_dac(number)
        DAC_MAP[number]
      end
    
      def dac_write(dac_channel, value)
        ESP32::GPIO.analog_write(dac_channel, value)
      end
    end
  end
end