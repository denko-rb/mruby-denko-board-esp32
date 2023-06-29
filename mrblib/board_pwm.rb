module Denko
  class Board
    #
    # LEDC to PWM Channel Mapping
    #
    # ESP32 chips can have different numbers of LEDC modes (groups), and channels and
    # timers within those groups.
    # 
    # Build an array (LEDC_CHANNEL_MAP) to map these resources to "virtual channels", following these rules:
    #   1) High speed groups are lower indexed in the array than low speed groups.
    #   2) Each timer is used by 2 sequential channels. Generally 4 timers and 8 channels per group.
    #   3) Timers and channels within a group are used up in ascending numerical order.
    #   4) The virtual channels will be assigned in ascending numerical order.
    #
    # Every chip has at least these 6 low speed channels defined.
    #
    ledc_temp = [
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_0],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_1],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_2],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_3],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_4],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_5],
    ]
    
    # Original ESP32, S2 and S3 have channels 6,7.
    if [CHIP_ESP32, CHIP_ESP32S2, CHIP_ESP32S3].include?(CHIP_MODEL)
      ledc_temp = ledc_temp + [
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_6],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_7],
      ]
    end
  
    # Original ESP32 has 8 more high speed channels that get added to the start of the array.
    if (CHIP_MODEL == CHIP_ESP32)
      ledc_temp =  [
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_0],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_0, LEDC_CHANNEL_1],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_2],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_1, LEDC_CHANNEL_3],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_4],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_2, LEDC_CHANNEL_5],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_6],
        [LEDC_HIGH_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_7],
      ] + ledc_temp
    end
  
    LEDC_CHANNEL_MAP = ledc_temp.dup

    # Tracks which pin is assigned to which channel.
    def ledc_pins
      @ledc_pins ||= Array.new(LEDC_CHANNEL_MAP.length)
    end

    # Assign or reassign a channel to the given pin.
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
  
    # Configure the hardware for the given pin and channel.
    def ledc_config(pin, vchan)
      vchan = ledc_assign(pin)
      group = LEDC_CHANNEL_MAP[vchan][0]
      timer = LEDC_CHANNEL_MAP[vchan][1]
      channel = LEDC_CHANNEL_MAP[vchan][2]
      # Just Arduino defaults for now
      resolution = LEDC_TIMER_8_BIT
      frequency = 1000
    
      ESP32::LEDC.timer_config(group, timer, resolution, frequency)
      ESP32::LEDC.channel_config(pin, group, timer, channel)
    end
  
    # Deconfigure hardware for a given pin and free any virtual channel it was using.
    def ledc_detach(pin)
      ESP32::LEDC.unset_pin(pin)
      (0..ledc_pins.length - 1).each do |index|
        ledc_pins[index] = nil if ledc_pins[index] == pin
      end
    end
  
    #
    # Denko Board PWM interface.
    # 
    def pwm_setup(pin)
      vchan = ledc_assign(pin)
      ledc_config(pin, vchan)
      # Component stores virtual channel.
      vchan
    end

    def pwm_write(pin, value)
      vchan = @lec_pins.find_index(pin)
      unless vchan
        vchan = pwm_setup(pin)
      end
      return unless vchan
      
      ESP32::LEDC.set_duty(LEDC_CHANNEL_MAP[vchan][0], LEDC_CHANNEL_MAP[vchan][2], value)
    end
  end
end
