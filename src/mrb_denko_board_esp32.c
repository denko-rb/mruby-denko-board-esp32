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
mrb_micro_sleep(mrb_state *mrb, mrb_value self) {
  mrb_int microseconds;
  mrb_get_args(mrb, "i", &microseconds);
  esp_rom_delay_us(microseconds);
  return self;
}

// Kernel#sleep
// Takes seconds. Uses RTOS vTaskDelay.
static mrb_value
mrb_sleep(mrb_state *mrb, mrb_value self) {
  mrb_int seconds;
  mrb_get_args(mrb, "i", &seconds);
  vTaskDelay((seconds * 1000) / portTICK_PERIOD_MS);
  return self;
}

// Denko::Board#deep_sleep
// Takes seconds. Uses esp_deep_sleep.
static mrb_value
mrb_deep_sleep(mrb_state *mrb, mrb_value self) {
  mrb_int seconds;
  mrb_get_args(mrb, "i", &seconds);
  esp_deep_sleep(seconds * 1000000);
  return self;
}

// Denko::Board#time
// Returns time in microseconds since application start. Uses esp_timer_get_time.
static mrb_value
mrb_micros(mrb_state *mrb, mrb_value self) {
  return mrb_float_value(mrb, esp_timer_get_time());
}

void
mrb_mruby_denko_board_esp32_gem_init(mrb_state* mrb) {
  // Global methods
  mrb_define_method(mrb, mrb->kernel_module, "sleep", mrb_sleep, MRB_ARGS_REQ(1));

  // Denko module
  struct RClass *mrb_Denko = mrb_define_module(mrb, "Denko");
    
  // Denko::Board class
  struct RClass *mrb_Denko_Board = mrb_define_class_under(mrb, mrb_Denko, "Board", mrb->object_class);
  mrb_define_method(mrb, mrb_Denko_Board, "micro_sleep", mrb_micro_sleep, MRB_ARGS_REQ(1));
  mrb_define_method(mrb, mrb_Denko_Board, "deep_sleep",  mrb_deep_sleep,  MRB_ARGS_REQ(1));
  mrb_define_method(mrb, mrb_Denko_Board, "time",        mrb_micros,      MRB_ARGS_NONE());
}

void
mrb_mruby_denko_board_esp32_gem_final(mrb_state* mrb) {
}
