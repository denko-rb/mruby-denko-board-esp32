#include <mruby.h>
#include <mruby/value.h>

#include "driver/gpio.h"
#include "driver/dac_oneshot.h"
#include "esp_adc/adc_oneshot.h"

// Defined by ESP-IDF:
// GPIO_MODE_DEF_INPUT  (BIT0)
// GPIO_MODE_DEF_OUTPUT (BIT1)
// GPIO_MODE_DEF_OD     (BIT2)
#define GPIO_MODE_DEF_PULLUP    (BIT3)
#define GPIO_MODE_DEF_PULLDOWN  (BIT4)

// Defined by ESP-IDF:
// GPIO_MODE_INPUT
// GPIO_MODE_OUTPUT
#define GPIO_MODE_INPUT_PULLUP           ((GPIO_MODE_DEF_INPUT)|(GPIO_MODE_DEF_PULLUP))
#define GPIO_MODE_INPUT_PULLDOWN         ((GPIO_MODE_DEF_INPUT)|(GPIO_MODE_DEF_PULLDOWN))
#define GPIO_MODE_INPUT_PULLUP_PULLDOWN  ((GPIO_MODE_DEF_INPUT)|(GPIO_MODE_DEF_PULLUP)|(GPIO_MODE_DEF_PULLDOWN))
#define GPIO_MODE_INPUT_OUTPUT           ((GPIO_MODE_DEF_INPUT) |(GPIO_MODE_DEF_OUTPUT))
#define GPIO_MODE_INPUT_OUTPUT_OD        ((GPIO_MODE_DEF_INPUT) |(GPIO_MODE_DEF_OUTPUT)|(GPIO_MODE_DEF_OD))
#define GPIO_MODE_OUTPUT_OD              ((GPIO_MODE_DEF_OUTPUT)|(GPIO_MODE_DEF_OD))

// Pin Mode
static mrb_value
mrb_esp32_gpio_pin_mode(mrb_state *mrb, mrb_value self) {
  mrb_value pin, dir;

  mrb_get_args(mrb, "oo", &pin, &dir);

  if (!mrb_fixnum_p(pin) || !mrb_fixnum_p(dir)) {
    return mrb_nil_value();
  }

  esp_rom_gpio_pad_select_gpio(mrb_fixnum(pin));
  
  // Clear pullup and pulldown bits (BIT3 and BIT4) when setting direction.
  gpio_set_direction(mrb_fixnum(pin), mrb_fixnum(dir) & ~(GPIO_MODE_DEF_PULLUP | GPIO_MODE_DEF_PULLDOWN));

  // Set correct pull mode based on bits 3 and 4.
  uint32_t pull = mrb_fixnum(dir) >> 3;
  switch(pull) {
    case 0: gpio_set_pull_mode(mrb_fixnum(pin), GPIO_FLOATING);        break;
    case 1: gpio_set_pull_mode(mrb_fixnum(pin), GPIO_PULLUP_ONLY);     break;
    case 2: gpio_set_pull_mode(mrb_fixnum(pin), GPIO_PULLDOWN_ONLY);   break;
    case 3: gpio_set_pull_mode(mrb_fixnum(pin), GPIO_PULLUP_PULLDOWN); break;
  }

  return self;
}

// Digital Read
static mrb_value
mrb_esp32_gpio_digital_read(mrb_state *mrb, mrb_value self) {
  mrb_value pin;

  mrb_get_args(mrb, "o", &pin);

  if (!mrb_fixnum_p(pin)) {
    return mrb_nil_value();
  }

  return mrb_fixnum_value(gpio_get_level(mrb_fixnum(pin)));
}

// Digital Write
static mrb_value
mrb_esp32_gpio_digital_write(mrb_state *mrb, mrb_value self) {
  mrb_value pin, level;

  mrb_get_args(mrb, "oo", &pin, &level);

  if (!mrb_fixnum_p(pin) || !mrb_fixnum_p(level)) {
    return mrb_nil_value();
  }

  gpio_set_level(mrb_fixnum(pin), mrb_fixnum(level));

  return self;
}

// Analog Read
static mrb_value
mrb_esp32_gpio_analog_read(mrb_state *mrb, mrb_value self) {
  mrb_value ch;

  mrb_get_args(mrb, "o", &ch);

  if (!mrb_fixnum_p(ch)) {
    return mrb_nil_value();
  }
  
  // Handle
  adc_oneshot_unit_handle_t adc1_handle;
  adc_oneshot_unit_init_cfg_t init_config1 = {
      .unit_id = ADC_UNIT_1,
      .ulp_mode = ADC_ULP_MODE_DISABLE,
  };
  ESP_ERROR_CHECK(adc_oneshot_new_unit(&init_config1, &adc1_handle));
  
  // Always use maximum resolution and attenuation.
  // Should make this configurable.
  adc_oneshot_chan_cfg_t config = {
      .bitwidth = ADC_BITWIDTH_DEFAULT,
      .atten = ADC_ATTEN_DB_11,
  };
  ESP_ERROR_CHECK(adc_oneshot_config_channel(adc1_handle, mrb_fixnum(ch), &config));
  
  // Read and Delete
  int adc_result;
  ESP_ERROR_CHECK(adc_oneshot_read(adc1_handle, mrb_fixnum(ch), &adc_result));
  ESP_ERROR_CHECK(adc_oneshot_del_unit(adc1_handle));

  return mrb_fixnum_value(adc_result);
}

// Analog Write (DACs not available on some chips)
#ifdef SOC_DAC_SUPPORTED
static mrb_value
mrb_esp32_gpio_analog_write(mrb_state *mrb, mrb_value self) {
  mrb_value ch, vol;

  mrb_get_args(mrb, "oo", &ch, &vol);

  if (!mrb_fixnum_p(ch) || !mrb_fixnum_p(vol)) {
    return mrb_nil_value();
  }
  
  // Handle
  dac_oneshot_handle_t chan_handle;
  
  // Configuration
  dac_oneshot_config_t chan_cfg = {
      .chan_id = mrb_fixnum(ch),
  };
  ESP_ERROR_CHECK(dac_oneshot_new_channel(&chan_cfg, &chan_handle));
  
  // Write
  ESP_ERROR_CHECK(dac_oneshot_output_voltage(chan_handle, mrb_fixnum(vol)));
  
  return self;
}
#endif
