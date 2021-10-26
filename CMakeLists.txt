set(CMAKE_SYSTEM_PROCESSOR cortex-m3)
set(CMAKE_SYSTEM_NAME Generic)

cmake_minimum_required(VERSION 3.4.1)
project(ARM)
set(TARGET_NAME ARM_COMP)

# 设置交叉编译器
set(COMPILER_PREFIX arm-none-eabi-)
set(CMAKE_C_COMPILER        ${COMPILER_PREFIX}gcc)
set(CMAKE_CXX_COMPILER      ${COMPILER_PREFIX}g++)
set(CMAKE_ASM_COMPILER      ${COMPILER_PREFIX}gcc)
set(CMAKE_OBJCOPY           ${COMPILER_PREFIX}objcopy)
set(CMAKE_OBJDUMP           ${COMPILER_PREFIX}objdump)

# find additional toolchain executables
find_program(ARM_SIZE_EXECUTABLE    ${COMPILER_PREFIX}size)
find_program(ARM_GDB_EXECUTABLE     ${COMPILER_PREFIX}gdb)
find_program(ARM_OBJCOPY_EXECUTABLE ${COMPILER_PREFIX}objcopy)
find_program(ARM_OBJDUMP_EXECUTABLE ${COMPILER_PREFIX}objdump)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# search for program/library/include in the build host directories
#set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
#set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

#型号
set(MCU_FAMILY STM32F103xE)
#布局文件
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/STM32G030K6Tx_FLASH.ld)

# 内核相关
set(CPU         "-mcpu=cortex-m3")
set(FPU         "")
set(FLOAT_ABI   "")

add_definitions(
    -DUSE_HAL_DRIVER
    -DSTM32F103xE
)

# 编译选项
if(CMAKE_BUILD_TYPE MATCHES Debug)
    set(OPT     "-g -gdwarf-2")
elseif(CMAKE_BUILD_TYPE MATCHES Release)
    set(OPT     "-Og")
endif()

set(MCU_FLAGS       "${CPU} -mthumb ${FPU} ${FLOAT_ABI}")
set(CMAKE_C_FLAGS   "${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections -std=gnu99")
set(CMAKE_CXX_FLAGS "${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections -fno-rtti -fno-exceptions -fno-builtin")
set(CMAKE_ASM_FLAGS "${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections -x assembler-with-cpp")

#include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain.cmake)
set(DRIVERS_PATH    ${CMAKE_SOURCE_DIR}/Drivers)
set(CMSIS_PATH      ${DRIVERS_PATH}/CMSIS)
set(HAL_DRV_PATH    ${DRIVERS_PATH}/STM32F1xx_HAL_Driver)

include_directories(
    ${CMAKE_SOURCE_DIR}/Inc
    ${CMSIS_PATH}/Include
)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/Src MAIN_SRCS)
add_executable(${TARGET_NAME}.elf ${MAIN_SRCS} startup_stm32f103xe.s)
add_subdirectory(${HAL_DRV_PATH})