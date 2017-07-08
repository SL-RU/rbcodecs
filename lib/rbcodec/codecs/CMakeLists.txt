project (Codecs)
file(STRINGS SOURCES_lib src_fls)

message("codecs library")
#message(${src_fls})

add_library (codecs ${src_fls})

target_include_directories (codecs PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/lib
  )

