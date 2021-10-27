cmake_minimum_required(VERSION 3.4.1)
set(TARGET_NAME app_arm)
include(${CMAKE_SOURCE_DIR}/cmake/stm32.cmake)
project(ARM)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/lib)
enable_language(ASM)

set(USER_PATH           ${CMAKE_SOURCE_DIR}/User)
set(STM32CUBE_PATH      ${CMAKE_SOURCE_DIR}/STM32Cube)

set(AXF_FILE ${EXECUTABLE_OUTPUT_PATH}/${TARGET_NAME}.axf)
set(BIN_FILE ${EXECUTABLE_OUTPUT_PATH}/${TARGET_NAME}.bin)
set(HEX_FILE ${EXECUTABLE_OUTPUT_PATH}/${TARGET_NAME}.hex)

add_executable(${TARGET_NAME}.axf)
add_subdirectory(${STM32CUBE_PATH})
add_subdirectory(${USER_PATH})

add_custom_command(TARGET "${TARGET_NAME}.axf" POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Obinary   ${AXF_FILE} ${BIN_FILE}
    COMMAND ${CMAKE_OBJCOPY} -Oihex     ${AXF_FILE} ${HEX_FILE}
    COMMENT "Building ${PROJECT_NAME}.bin and ${PROJECT_NAME}.hex"
    COMMAND ${CMAKE_SIZE} --format=berkeley ${AXF_FILE} ${HEX_FILE}
    COMMENT "Invoking: Cross ARM GNU Print Size"
)

