module Denko
  class Board
    #
    # Map GPIO numbers to their associated ADC channels (if any) in a hash.
    # Varies by chip and ADC2 is ignored for now.
    #
    # Newer chips have ADC channels in order, so we need only the lowest GPIO
    # with an ADC (offset) and number of ADC channels (count).
    #
    adc_offset = nil
    adc_count  = nil 
  
    # S2 and S3 
    if (CHIP_MODEL == CHIP_ESP32S2) || (CHIP_MODEL == CHIP_ESP32S3)
      adc_offset = 1; adc_count = 10 
    end
  
    # C2 and C3
    if (CHIP_MODEL == CHIP_ESP32C2) || (CHIP_MODEL == CHIP_ESP32C3)
      adc_offset = 0; adc_count = 5 
    end
  
    # C6
    if (CHIP_MODEL == CHIP_ESP32C6)
      adc_offset = 0; adc_count = 7
    end
  
    # H2
    if (CHIP_MODEL == CHIP_ESP32H2)
      adc_offset = 1; adc_count = 5 
    end
  
    # Dynamically generate hash if board matches.
    if (adc_offset && adc_count)
      adc1_map_temp = {}
      i = 0
      while(i < adc_count) do
        adc1_map_temp[adc_offset+i] = ESP32::Constants.const_get("ADC_CHANNEL_#{i}")
        i += 1
      end
      ADC1_MAP = adc1_map_temp.dup
    # Original ESP32 has this weird mapping.
    elsif (CHIP_MODEL == CHIP_ESP32)
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
    # No ADC?
    else
      ADC1_MAP = {}
    end

    def map_adc(number)
      ADC1_MAP[number]
    end
  
    def adc_read(adc_channel)
      ESP32::GPIO.analog_read(adc_channel)
    end
  end
end
