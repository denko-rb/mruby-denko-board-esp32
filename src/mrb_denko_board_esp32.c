#include <mruby.h>
#include "mrb_esp32_system.c"
#include "mrb_esp32_gpio.c"
#include "mrb_esp32_custom.c"

void
mrb_mruby_denko_board_esp32_gem_init(mrb_state* mrb) {
  // Denko module
  struct RClass *mrb_Denko = mrb_define_module(mrb, "Denko");
  
  // Denko::Board class
  struct RClass *mrb_Denko_Board = mrb_define_class_under(mrb, mrb_Denko, "Board", mrb->object_class);
  
  // Pass a C constant through to mruby, defined inside Denko::Board.
  #define define_const(SYM) \
  do { \
    mrb_define_const(mrb, mrb_Denko_Board, #SYM, mrb_fixnum_value(SYM)); \
  } while (0)
  
  //////////////////////////////////////
  // System & Board Constant Definitions
  //////////////////////////////////////
  
  // Constants from SDK
  //
  // ESP32::System.chip_model returns a constant from the esp_chip_model_t enum:
  // https://github.com/espressif/esp-idf/blob/master/components/esp_hw_support/include/esp_chip_info.h
  define_const(CHIP_ESP32);
  define_const(CHIP_ESP32S2);
  define_const(CHIP_ESP32S3);
  define_const(CHIP_ESP32C3);
  define_const(CHIP_ESP32H2);
  define_const(CHIP_ESP32C2);
  #if ESP_IDF_VERSION >= ESP_IDF_VERSION_VAL(5, 1, 0)
    define_const(CHIP_ESP32C6);
    define_const(CHIP_POSIX_LINUX);
  #endif
  // define_const(CHIP_ESP32P4);
  
  ////////////////////////////////////
  // System & Board Method Definitions
  ////////////////////////////////////
  
  // From mrb_esp32_system.c
  // Class methods on Denko::Board
  mrb_define_module_function(mrb, mrb_Denko_Board, "sdk_version", mrb_esp32_system_sdk_version,   MRB_ARGS_NONE());
  mrb_define_module_function(mrb, mrb_Denko_Board, "chip_model",  mrb_esp32_get_chip_model,       MRB_ARGS_NONE());
  // Instance methods on Denko::Board
  mrb_define_method(mrb, mrb_Denko_Board, "free_memory", mrb_esp32_system_available_memory, MRB_ARGS_NONE());
  mrb_define_method(mrb, mrb_Denko_Board, "restart",     mrb_esp32_system_restart,          MRB_ARGS_NONE());
  mrb_define_method(mrb, mrb_Denko_Board, "time",        mrb_esp32_esp_timer_get_time,      MRB_ARGS_NONE());

  // From mrb_esp32_custom.c
  // Kernel methods
  mrb_define_method(mrb, mrb->kernel_module, "sleep",    mrb_esp32_custom_sleep,            MRB_ARGS_REQ(1));
  // Instance methods on Denko::Board
  mrb_define_method(mrb, mrb_Denko_Board, "deep_sleep",  mrb_esp32_custom_deep_sleep,       MRB_ARGS_REQ(1));
  mrb_define_method(mrb, mrb_Denko_Board, "micro_sleep", mrb_esp32_custom_micro_sleep,      MRB_ARGS_REQ(1));

  ////////////////////////////
  // GPIO Constant Definitions
  ////////////////////////////
  
  // Constants from SDK
  //
  // GPIO numbers available on each variant found here:
  // https://github.com/espressif/esp-idf/blob/67552c31da/components/hal/include/hal/gpio_types.h
  //
  // All chips define GPIO_NUM_MAX and GPIO_NUM_0..GPIO_NUM_20.  
  define_const(GPIO_NUM_MAX);
  define_const(GPIO_NUM_0);
  define_const(GPIO_NUM_1);
  define_const(GPIO_NUM_2);
  define_const(GPIO_NUM_3);
  define_const(GPIO_NUM_4);
  define_const(GPIO_NUM_5);
  define_const(GPIO_NUM_6);
  define_const(GPIO_NUM_7);
  define_const(GPIO_NUM_8);
  define_const(GPIO_NUM_9);
  define_const(GPIO_NUM_10);
  define_const(GPIO_NUM_11);
  define_const(GPIO_NUM_12);
  define_const(GPIO_NUM_13);
  define_const(GPIO_NUM_14);
  define_const(GPIO_NUM_15);
  define_const(GPIO_NUM_16);
  define_const(GPIO_NUM_17);
  define_const(GPIO_NUM_18);
  define_const(GPIO_NUM_19);
  define_const(GPIO_NUM_20);

  // Original, S2, S3, C3, C6 and H2 (all except C2) have 21.
  #if defined(CONFIG_IDF_TARGET_ESP32)  || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3)|| defined(CONFIG_IDF_TARGET_ESP32C3) || \
      defined(CONFIG_IDF_TARGET_ESP32C6)|| defined(CONFIG_IDF_TARGET_ESP32H2)      
    define_const(GPIO_NUM_21);
  #endif
  
  // Original, C6 and H2 have 22,23,25.
  #if defined(CONFIG_IDF_TARGET_ESP32) || defined(CONFIG_IDF_TARGET_ESP32C6) || \
      defined(CONFIG_IDF_TARGET_ESP32H2)
    define_const(GPIO_NUM_22);
    define_const(GPIO_NUM_23);
    define_const(GPIO_NUM_25);
  #endif
    
  // C6 and H2 have 24.
  #if defined(CONFIG_IDF_TARGET_ESP32C6) || defined(CONFIG_IDF_TARGET_ESP32H2)
    define_const(GPIO_NUM_24);
  #endif
    
  // Original, S2, S3, C6 ad H2 have 26,27.
  #if defined(CONFIG_IDF_TARGET_ESP32)   || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3) || defined(CONFIG_IDF_TARGET_ESP32C6) || \
      defined(CONFIG_IDF_TARGET_ESP32H2)
    define_const(GPIO_NUM_26);
    define_const(GPIO_NUM_27);
  #endif
    
  // Original, S2, S3 and C6 have 28..30.
  #if defined(CONFIG_IDF_TARGET_ESP32)   || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3) || defined(CONFIG_IDF_TARGET_ESP32C6)
    define_const(GPIO_NUM_28);
    define_const(GPIO_NUM_29);
    define_const(GPIO_NUM_30);
  #endif
    
  // Original, S2 and S3 have 31..39.
  #if defined(CONFIG_IDF_TARGET_ESP32)   || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3)
    define_const(GPIO_NUM_31);    
    define_const(GPIO_NUM_32);
    define_const(GPIO_NUM_33);
    define_const(GPIO_NUM_34);
    define_const(GPIO_NUM_35);
    define_const(GPIO_NUM_36);
    define_const(GPIO_NUM_37);
    define_const(GPIO_NUM_38);
    define_const(GPIO_NUM_39);
  #endif

  // S2 and S3 have 40..46.
  #if defined(CONFIG_IDF_TARGET_ESP32S2) || defined(CONFIG_IDF_TARGET_ESP32S3)
    define_const(GPIO_NUM_40);    
    define_const(GPIO_NUM_41);
    define_const(GPIO_NUM_42);
    define_const(GPIO_NUM_43);
    define_const(GPIO_NUM_44);
    define_const(GPIO_NUM_45);
    define_const(GPIO_NUM_46);
  #endif

  // S3 alone has 47,48.
  #if defined(CONFIG_IDF_TARGET_ESP32S3)
    define_const(GPIO_NUM_47);
    define_const(GPIO_NUM_48);
  #endif
    
  //
  // All chips have ADC_CHANNEL_0..ADC_CHANNEL_9 defined, but limit them instead
  // to the channels which are actually connected to GPIOs.
  //
  // All chips connect ADC_CHANNEL_0..ADC_CHANNEL_4 to a GPIO.
  define_const(ADC_CHANNEL_0);
  define_const(ADC_CHANNEL_1);
  define_const(ADC_CHANNEL_2);
  define_const(ADC_CHANNEL_3);
  define_const(ADC_CHANNEL_4);

  // Original, S2, S3 and C6 have 5,6.
  #if defined(CONFIG_IDF_TARGET_ESP32)   || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3) || defined(CONFIG_IDF_TARGET_ESP32C6)
    define_const(ADC_CHANNEL_5);
    define_const(ADC_CHANNEL_6);
  #endif

  // Original, S2 and S3 have 7,8,9.
  // Note: Original ESP32 has 8,9 only on ADC2 which isn't implemented yet.
  #if defined(CONFIG_IDF_TARGET_ESP32)   || defined(CONFIG_IDF_TARGET_ESP32S2) || \
      defined(CONFIG_IDF_TARGET_ESP32S3)
    define_const(ADC_CHANNEL_7);
    define_const(ADC_CHANNEL_8);
    define_const(ADC_CHANNEL_9);
  #endif

  // Original and S2 have DACs.
  #ifdef SOC_DAC_SUPPORTED
    define_const(DAC_CHAN_0);
    define_const(DAC_CHAN_1);
    // Old versions of above. Deprecated.
    define_const(DAC_CHANNEL_1);
    define_const(DAC_CHANNEL_2);
  #endif

  ////////////////////////////
  // GPIO Method Definitions
  ////////////////////////////
  
  // From mrb_esp32_gpio.c
  // Denko::Board instance methods
  mrb_define_method(mrb, mrb_Denko_Board, "gpio_set_direction", mrb_esp32_gpio_pin_mode,      MRB_ARGS_REQ(2));
  mrb_define_method(mrb, mrb_Denko_Board, "digital_write",      mrb_esp32_gpio_digital_write, MRB_ARGS_REQ(2));
  mrb_define_method(mrb, mrb_Denko_Board, "digital_read",       mrb_esp32_gpio_digital_read,  MRB_ARGS_REQ(1));
  mrb_define_method(mrb, mrb_Denko_Board, "adc_read_channel",   mrb_esp32_gpio_analog_read,   MRB_ARGS_REQ(1));
  // DAC available only on some chips.
  #ifdef SOC_DAC_SUPPORTED
    mrb_define_const(mrb, mrb_Denko_Board,  "SOC_DAC_SUPPORTED", mrb_true_value());
    mrb_define_method(mrb, mrb_Denko_Board, "dac_write_channel", mrb_esp32_gpio_analog_write, MRB_ARGS_REQ(2));
  #else
    mrb_define_const(mrb, mrb_Denko_Board, "SOC_DAC_SUPPORTED", mrb_false_value());
  #endif    
  // Some of these constants also come from mrb_esp32_gpio.c. Not native to SDK.
  define_const(GPIO_MODE_INPUT);
  define_const(GPIO_MODE_OUTPUT);
  define_const(GPIO_MODE_INPUT_PULLUP);
  define_const(GPIO_MODE_INPUT_PULLDOWN);
  define_const(GPIO_MODE_INPUT_PULLUP_PULLDOWN);
  define_const(GPIO_MODE_INPUT_OUTPUT);
  define_const(GPIO_MODE_INPUT_OUTPUT_OD);
  define_const(GPIO_MODE_OUTPUT_OD);
  // GPIO logic levels.
  mrb_define_const(mrb, mrb_Denko_Board, "LOW", mrb_fixnum_value(0));
  mrb_define_const(mrb, mrb_Denko_Board, "HIGH", mrb_fixnum_value(1));
}

void
mrb_mruby_denko_board_esp32_gem_final(mrb_state* mrb) {
}
