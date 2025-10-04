cmake_minimum_required(VERSION 3.29)
project(firmware)

set(CMAKE_CXX_STANDARD 20)
enable_language(ASM)


add_executable(firmware
        crt0.S
        main.cpp)

target_compile_options(firmware PRIVATE -march=rv32i -mabi=ilp32)
target_link_options(firmware PRIVATE -T ${CMAKE_SOURCE_DIR}/linker.ld -nostdlib -ffreestanding)