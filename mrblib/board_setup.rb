module Denko
  class Board
    include ESP32::Constants
    CHIP_MODEL = ESP32::System.chip_model
  end
end
