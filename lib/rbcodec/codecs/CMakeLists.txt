file(STRINGS SOURCES_lib src_fls)

message("codecs library")
#message(${src_fls})

add_library (codecs ${src_fls})

target_include_directories (codecs PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/lib
  )
target_include_directories (codecs INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/lib
  )
set_target_properties(codecs PROPERTIES COMPILE_FLAGS "-fPIC -fstrict-aliasing -DCODEC")
TARGET_LINK_LIBRARIES(codecs rockbox_sys)
TARGET_LINK_LIBRARIES(codecs fixedpoint)
TARGET_LINK_LIBRARIES(codecs tlsf)
TARGET_LINK_LIBRARIES(codecs rbcodec)

  
add_subdirectory(libffmpegFLAC)

#message(${CMAKE_C_FLAGS})
ADD_EXECUTABLE(flac.elf flac.c codec_crt0.c)

set_target_properties(flac.elf PROPERTIES COMPILE_FLAGS "-fPIC -fstrict-aliasing -DCODEC")
set_target_properties(flac.elf PROPERTIES LINK_FLAGS "${LINKER_FLAGS} -lgcc -shared -Wl,-z,defs -Wl,-z,defs -Wl,--gc-sections")
#target_compile_definitions(flac.elf PRIVATE "-n -nostartfiles -fstrict-aliasing -DCODEC")
TARGET_LINK_LIBRARIES(flac.elf codecs)
TARGET_LINK_LIBRARIES(flac.elf libffmpegFLAC)

ADD_CUSTOM_TARGET(flac.codec DEPENDS flac.elf COMMAND objcopy flac.elf flac.codec)
