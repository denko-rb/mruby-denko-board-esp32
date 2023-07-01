#include <mruby.h>
#include <mruby/value.h>

#include <stdio.h>

#include "esp_idf_version.h"
#include "esp_system.h"
#include "esp_sleep.h"
#include "esp_timer.h"
#include "esp_chip_info.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

// Denko::Board#micro_sleep
// Takes microseconds. Uses esp_rom_delay.
static mrb_value
mrb_esp32_custom_micro_sleep(mrb_state *mrb, mrb_value self) {
  mrb_int microseconds;
  mrb_get_args(mrb, "i", &microseconds);
  esp_rom_delay_us(microseconds);
  return self;
}

// Kernel#sleep
// Takes seconds. Uses RTOS vTaskDelay.
static mrb_value
mrb_esp32_custom_sleep(mrb_state *mrb, mrb_value self) {
  mrb_float seconds;
  mrb_get_args(mrb, "f", &seconds);
  vTaskDelay((seconds * 1000) / portTICK_PERIOD_MS);
  return self;
}

// Denko::Board#deep_sleep
// Takes seconds. Uses esp_deep_sleep.
static mrb_value
mrb_esp32_custom_deep_sleep(mrb_state *mrb, mrb_value self) {
  mrb_int seconds;
  mrb_get_args(mrb, "i", &seconds);
  esp_deep_sleep(seconds * 1000000);
  return self;
}
