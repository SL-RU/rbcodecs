#project (Rockbox_sys)
file(STRINGS SOURCES s)

message("rockbox_sys library")
#message(${src_fls})

set (src "")
FOREACH(f ${s})
  LIST(APPEND src "${CMAKE_CURRENT_SOURCE_DIR}/${f}")
ENDFOREACH(f)
set (rockbox_sys_src ${src})# PARENT_SCOPE)
#message(${src})


set (rockbox_sys_h PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR})
#  PARENT_SCOPE)

add_library(rockbox_sys ${rockbox_sys_src})
target_include_directories(rockbox_sys INTERFACE ${rockbox_sys_h})

TARGET_LINK_LIBRARIES(rockbox_sys tlsf)

