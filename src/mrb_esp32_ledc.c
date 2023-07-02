#include <mruby.h>
#include <mruby/value.h>

#include "soc/io_mux_reg.h"
#include "driver/gpio.h"
#include "driver/ledc.h"

static mrb_value
mrb_esp32_ledc_timer_config(mrb_state *mrb, mrb_value self) {
  mrb_value group, timer, res, freq;

  mrb_get_args(mrb, "oooo", &group, &timer, &res, &freq);

  if (!mrb_fixnum_p(group) || !mrb_fixnum_p(timer) || !mrb_fixnum_p(res) || !mrb_fixnum_p(freq)) {
    return mrb_nil_value();
  }

  // Timer config
  ledc_timer_config_t ledc_timer = {
      .speed_mode       = mrb_fixnum(group),
      .timer_num        = mrb_fixnum(timer),
      .duty_resolution  = mrb_fixnum(res),
      .freq_hz          = mrb_fixnum(freq),
      .clk_cfg          = LEDC_AUTO_CLK
  };
  ESP_ERROR_CHECK(ledc_timer_config(&ledc_timer));

  return self;
}

static mrb_value
mrb_esp32_ledc_channel_config(mrb_state *mrb, mrb_value self) {
  mrb_value pin, group, timer, ch;

  mrb_get_args(mrb, "oooo", &pin, &group, &timer, &ch);

  if (!mrb_fixnum_p(pin) || !mrb_fixnum_p(group) || !mrb_fixnum_p(timer) || !mrb_fixnum_p(ch)) {
    return mrb_nil_value();
  }

  // Channel config
  ledc_channel_config_t ledc_channel = {
      .gpio_num       = mrb_fixnum(pin),
      .speed_mode     = mrb_fixnum(group),
      .timer_sel      = mrb_fixnum(timer),
      .channel        = mrb_fixnum(ch),
      .intr_type      = LEDC_INTR_DISABLE,
      .duty           = 0, // Set duty to 0%
      .hpoint         = 0
  };
  ESP_ERROR_CHECK(ledc_channel_config(&ledc_channel));

  return self;
}

static mrb_value
mrb_esp32_ledc_set_duty(mrb_state *mrb, mrb_value self) {
  mrb_value group, ch, duty;

  mrb_get_args(mrb, "ooo", &group, &ch, &duty);

  if (!mrb_fixnum_p(group) || !mrb_fixnum_p(ch) || !mrb_fixnum_p(duty)) {
    return mrb_nil_value();
  }
  
  // Write the duty cycle to the channel.
  ESP_ERROR_CHECK(ledc_set_duty(mrb_fixnum(group), mrb_fixnum(ch), mrb_fixnum(duty)));
  ESP_ERROR_CHECK(ledc_update_duty(mrb_fixnum(group), mrb_fixnum(ch)));
  
  return self;
}

static mrb_value
mrb_esp32_ledc_set_freq(mrb_state *mrb, mrb_value self) {
  mrb_value group, timer, freq;

  mrb_get_args(mrb, "ooo", &group, &timer, &freq);

  if (!mrb_fixnum_p(group) || !mrb_fixnum_p(timer) || !mrb_fixnum_p(freq)) {
    return mrb_nil_value();
  }
  
  // Write the frequency to the timer.
  ESP_ERROR_CHECK(ledc_set_freq(mrb_fixnum(group), mrb_fixnum(timer), mrb_fixnum(freq)));
    
  return self;
}

static mrb_value
mrb_esp32_ledc_stop(mrb_state *mrb, mrb_value self) {
  mrb_value group, ch, idle;

  mrb_get_args(mrb, "ooo", &group, &ch, &idle);

  if (!mrb_fixnum_p(group) || !mrb_fixnum_p(ch) || !mrb_fixnum_p(idle)) {
    return mrb_nil_value();
  }
  
  // Write the frequency to the timer.
  ESP_ERROR_CHECK(ledc_stop(mrb_fixnum(group), mrb_fixnum(ch), mrb_fixnum(idle)));
    
  return self;
}

static mrb_value
mrb_esp32_ledc_set_pin(mrb_state *mrb, mrb_value self) {
  mrb_value pin, group, ch;

  mrb_get_args(mrb, "ooo", &pin, &group, &ch);

  if (!mrb_fixnum_p(pin) || !mrb_fixnum_p(group) || !mrb_fixnum_p(ch)) {
    return mrb_nil_value();
  }
  
  // Write the frequency to the timer.
  ESP_ERROR_CHECK(ledc_set_pin(mrb_fixnum(pin), mrb_fixnum(group), mrb_fixnum(ch)));
    
  return self;
}

static mrb_value
mrb_esp32_ledc_unset_pin(mrb_state *mrb, mrb_value self) {
  mrb_value pin;

  mrb_get_args(mrb, "o", &pin);

  if (!mrb_fixnum_p(pin)) {
    return mrb_nil_value();
  }
  
  // PIN_FUNC_GPIO is integer 2, which returns the pin to normal GPIO mode.
  // Last param is output inversion.
  gpio_iomux_out(mrb_fixnum(pin), PIN_FUNC_GPIO, false);
    
  return self;
}
