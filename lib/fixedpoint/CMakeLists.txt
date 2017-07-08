#project (Fixedpoint)
set (fixedpoint_src
  ${CMAKE_CURRENT_SOURCE_DIR}/fixedpoint.c
  PARENT_SCOPE)
#TARGET_LINK_LIBRARIES(fixedpoint rockbox_sys)

set (fixedpoint_h ${CMAKE_CURRENT_SOURCE_DIR} PARENT_SCOPE)

