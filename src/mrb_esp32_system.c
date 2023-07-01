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

static mrb_value
mrb_esp32_system_delay(mrb_state *mrb, mrb_value self) {
  mrb_int delay;
  mrb_get_args(mrb, "i", &delay);

  vTaskDelay(delay / portTICK_PERIOD_MS);

  return self;
}

static mrb_value
mrb_esp32_system_available_memory(mrb_state *mrb, mrb_value self) {
  return mrb_fixnum_value(esp_get_free_heap_size());
}

static mrb_value
mrb_esp32_system_sdk_version(mrb_state *mrb, mrb_value self) {
  return mrb_str_new_cstr(mrb, esp_get_idf_version());
}

static mrb_value
mrb_esp32_system_restart(mrb_state *mrb, mrb_value self) {
  esp_restart();
  return self;
}

static mrb_value
mrb_esp32_system_deep_sleep_for(mrb_state *mrb, mrb_value self) {
  mrb_int sleep_time;
  mrb_get_args(mrb, "i", &sleep_time);

  esp_deep_sleep(sleep_time);

  return self;
}

static mrb_value
mrb_esp32_esp_timer_get_time(mrb_state *mrb, mrb_value self) {
  return mrb_float_value(mrb, esp_timer_get_time());
}

static mrb_value
mrb_esp32_get_chip_model(mrb_state *mrb, mrb_value self) {
  esp_chip_info_t info;
  esp_chip_info(&info);
  return mrb_fixnum_value(info.model);
}