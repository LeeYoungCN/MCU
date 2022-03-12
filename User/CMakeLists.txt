target_include_directories(${TARGET_NAME}.axf PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Inc)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/Src CODE_SRCS)
target_sources(${TARGET_NAME}.axf PRIVATE ${CODE_SRCS})