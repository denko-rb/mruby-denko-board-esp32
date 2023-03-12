def sleep(time)
  ESP32::System.delay(time * 1000)
end

def deep_sleep(time)
  ESP32::System.deep_sleep_for(time * 1000)
end

def micros
  ESP32::Timer.get_time
end
