set_global_assignment -entity "CorePLL" -library "lib_CorePLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "CorePLL" -library "lib_CorePLL" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "CorePLL" -library "lib_CorePLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_CorePLL" -name SPD_FILE [file join $::quartus(sip_path) "CorePLL.spd"]

set_global_assignment -library "lib_CorePLL" -name MISC_FILE [file join $::quartus(sip_path) "CorePLL_sim/CorePLL.vo"]
