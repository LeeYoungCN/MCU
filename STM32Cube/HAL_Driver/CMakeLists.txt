target_include_directories(${TARGET_NAME}.axf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Inc)
target_include_directories(${TARGET_NAME}.axf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Inc/Lagacy)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src CODE_SRCS)
target_sources(${TARGET_NAME}.axf PRIVATE ${CODE_SRCS})