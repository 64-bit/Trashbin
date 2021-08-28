set_time_format -unit ns -decimal_places 3
# ##############################################################################  Create Input reference clocks
create_clock -name {CLOCK_125_p} -period 8.000 -waveform { 0.000 4.000 } 
# ##############################################################################  Now that we have created the custom clocks which will be base clocks,#  derive_pll_clock is used to calculate all remaining clocks for PLLs
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty