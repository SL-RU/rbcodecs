#project (RBcodec)
file(STRINGS SOURCES s)

message("rbcodec library")
#message(${src_fls})

set (src "")
FOREACH(f ${s})
  LIST(APPEND src "${CMAKE_CURRENT_SOURCE_DIR}/${f}")
ENDFOREACH(f)
set (rbcodec_src ${src}  PARENT_SCOPE)
message(${src})


set (rbcodec_h
  ${CMAKE_CURRENT_SOURCE_DIR}/dsp
  ${CMAKE_CURRENT_SOURCE_DIR}/metadata
  ${CMAKE_CURRENT_SOURCE_DIR}/codecs
  PARENT_SCOPE)

#TARGET_LINK_LIBRARIES(rbcodec rockbox_sys)
#TARGET_LINK_LIBRARIES(rbcodec fixedpoint)
#TARGET_LINK_LIBRARIES(rbcodec tlsf)

#add_subdirectory (codecs)
