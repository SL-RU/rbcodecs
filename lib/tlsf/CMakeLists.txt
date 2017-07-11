SET(tlsf_src ${CMAKE_CURRENT_SOURCE_DIR}/src/tlsf.c)

set (tlsf_h
  ${CMAKE_CURRENT_SOURCE_DIR}/src
  PARENT_SCOPE)

message(${tlsf_src})
add_library(tlsf ${tlsf_src})
target_include_directories(tlsf INTERFACE ${tlsf_h})

TARGET_LINK_LIBRARIES(tlsf rockbox_sys)
