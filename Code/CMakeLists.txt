cmake_minimum_required(VERSION 3.29)
project(firmware)

set(CMAKE_CXX_STANDARD 20)
enable_language(ASM)


add_executable(firmware
        crt0.S
        main.cpp
        GPIO_DRIVER.h
        MemoryMapPlan.h)

target_compile_options(firmware PRIVATE -march=rv32i -mabi=ilp32)
target_link_options(firmware PRIVATE -T ${CMAKE_SOURCE_DIR}/linker.ld -nostdlib -ffreestanding)

add_custom_command(TARGET firmware POST_BUILD

        COMMAND ${CMAKE_COMMAND} -E echo "Running post-build tasks..."
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:firmware> ${CMAKE_BINARY_DIR}/output/firmware.elf
        COMMAND riscv64-unknown-elf-objcopy --remove-section=.comment ${CMAKE_BINARY_DIR}/output/firmware.elf ${CMAKE_BINARY_DIR}/output/firmware_no_comments.elf
        COMMAND riscv64-unknown-elf-objdump -D ${CMAKE_BINARY_DIR}/output/firmware_no_comments.elf > dis.asm
        COMMAND riscv64-unknown-elf-objcopy -O ihex ${CMAKE_BINARY_DIR}/output/firmware_no_comments.elf ${CMAKE_BINARY_DIR}/output/firmware.hex --reverse-bytes=4
        COMMAND python3 ${PROJECT_SOURCE_DIR}/fixhex.py ${CMAKE_BINARY_DIR}/output/firmware.hex > ${CMAKE_BINARY_DIR}/output/firmware_fixed.hex
)