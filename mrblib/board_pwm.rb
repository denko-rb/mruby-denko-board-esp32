module Denko
  class Board
    #
    # LEDC to PWM Channel Mapping
    #
    # ESP32 chips can have different numbers of LEDC modes (groups), and channels and
    # timers within those groups.
    # 
    # Build an array (LEDC_MAP) to map these resources to "virtual channels", following these rules:
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
    if (LEDC_CHANNEL_MAX - 1) == 7
      ledc_temp = ledc_temp + [
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_6],
        [LEDC_LOW_SPEED_MODE, LEDC_TIMER_3, LEDC_CHANNEL_7],
      ]
    end

    # Original ESP32 has 8 high speed channels that are used preferrentially.
    if self.const_defined?("LEDC_HIGH_SPEED_MODE")
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

    # Final settings.
    LEDC_MAP = ledc_temp.dup
    LEDC_COUNT = LEDC_MAP.length

    def ledc_initialize
      @ledc_to_pin = Array.new(LEDC_MAP.length)
      @pin_to_ledc = Array.new(49)
    end

    # Assign or reassign a channel to the given pin.
    def ledc_assign(pin)
      vchan = 0
      while vchan < LEDC_COUNT do
        if @ledc_to_pin[vchan] == pin
          # Pin already assigned to this channel. Use it.
          return vchan
        elsif !@ledc_to_pin[vchan]
          # Channel unassigned. Use it.
          @ledc_to_pin[vchan] = pin
          @pin_to_ledc[pin] = vchan
          return vchan
        end
        vchan += 1
      end
      nil
    end

    # Configure settings for a given LEDC vchan assigned to given pin.
    def ledc_config(vchan)
      pin = @ledc_to_pin[vchan]
      raise "LEDC virtual channel #{vchan} isn't assigned to any pin" unless pin
      
      group   = LEDC_MAP[vchan][0]
      timer   = LEDC_MAP[vchan][1]
      channel = LEDC_MAP[vchan][2]
      
      # Just Arduino defaults for now.
      resolution = LEDC_TIMER_8_BIT
      frequency = 1000
    
      ledc_timer_config(group, timer, resolution, frequency)
      ledc_channel_config(pin, group, timer, channel)
    end
    
    def ledc_setup(pin)
      vchan = ledc_assign(pin)
      raise "no PWM (LEDC) channels available" unless vchan
      ledc_config(vchan)
      vchan
    end
    
    # Deconfigure hardware for a given pin and free any virtual channel it was using.
    def ledc_detach(pin)
      ledc_unset_pin(pin)
      vchan = @pin_to_ledc[pin]
      @ledc_to_pin[vchan] = nil
      @pin_to_ledc[pin]   = nil
    end

    #
    # Denko::Board PWM interface.
    # 
    def pwm_write(pin, value)
      vchan = @pin_to_ledc[pin] || ledc_setup(pin)
      ledc_set_duty(LEDC_MAP[vchan][0], LEDC_MAP[vchan][2], value)
    end
  end
end
