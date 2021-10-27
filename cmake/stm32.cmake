set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# 设置交叉编译器
set(COMPILER_PREFIX arm-none-eabi-)
set(CMAKE_C_COMPILER        ${COMPILER_PREFIX}gcc)
set(CMAKE_CXX_COMPILER      ${COMPILER_PREFIX}g++)
set(CMAKE_ASM_COMPILER      ${COMPILER_PREFIX}gcc)
set(CMAKE_OBJCOPY           ${COMPILER_PREFIX}objcopy)
set(CMAKE_OBJDUMP           ${COMPILER_PREFIX}objdump)
set(CMAKE_SIZE              ${COMPILER_PREFIX}size)

# find additional toolchain executables
find_program(ARM_SIZE_EXECUTABLE    ${COMPILER_PREFIX}size)
find_program(ARM_GDB_EXECUTABLE     ${COMPILER_PREFIX}gdb)
find_program(ARM_OBJCOPY_EXECUTABLE ${COMPILER_PREFIX}objcopy)
find_program(ARM_OBJDUMP_EXECUTABLE ${COMPILER_PREFIX}objdump)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# search for program/library/include in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 编译选项
if(CMAKE_BUILD_TYPE MATCHES Debug)
    set(OPT     "-g -gdwarf-2")
elseif(CMAKE_BUILD_TYPE MATCHES Release)
    set(OPT     "-Og")
endif()

# 内核相关
set(CPU         "-mcpu=cortex-m3")
set(FPU         "")
set(FLOAT_ABI   "")

set(MCU_FLAGS       "${CPU} -mthumb ${FPU} ${FLOAT_ABI}")
set(CMAKE_C_FLAGS   "${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_ASM_FLAGS "-x assembler-with-cpp ${MCU_FLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections")

file(GLOB LD_FILES ${CMAKE_SOURCE_DIR}/STM32Cube/Linker/*.ld)

set(LINKER_SCRIPT ${LD_FILES})
#要链接的库 对应makefile的 LIBS
set(LIBS "-lc -lm -lnosys")
set(CMAKE_EXE_LINKER_FLAGS "--specs=nano.specs -T${LINKER_SCRIPT} ${LIBS} -Wl,-Map=${CMAKE_SOURCE_DIR}/build/${TARGET_NAME}.map,--cref -Wl,--gc-sections")

add_definitions(-DUSE_HAL_DRIVER -D${MCU_NAME})