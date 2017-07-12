cmake_minimum_required (VERSION 2.8)
enable_language(C)

project(TestSDL C)

set(OPT "-Ofast")
set(USER_LINKER_FLAGS "-u _printf_float")
set(USER_CFLAGS "")


INCLUDE(FindPkgConfig)
PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2)

include_directories (
  ${CMAKE_CURRENT_SOURCE_DIR}/test
  ${SDL2_INCLUDE_DIRS}
  )

set(CMAKE_C_FLAGS "${PRJ_CFLAGS} ${OPT} -Wall -fdata-sections -ffunction-sections -g -gdwarf-2  ${USER_CFLAGS} ${CMAKE_C_FLAGS}")
set(LINKER_FLAGS "${USER_LINKER_FLAGS} ${LINKER_FLAGS} -ldl -lm -lc")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${LINKER_FLAGS}")

set(IS_ARM NO)

add_definitions(-DTARGET_ID=73
  -DROCKBOX
  -DMEMORYSIZE=8
  -DSDLAPP
  -DTARGET_NAME=sdlapp
  -DCONFIG_CODEC=SWCODEC
  -D__PCTOOL__
#  -DDEBUG=0
)

#include libs
add_subdirectory (lib)

#generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS "ON")

SET(TARGET ${CMAKE_PROJECT_NAME})
message(${TARGET})

add_executable(${TARGET}
  test/warble.c
#  ${lib_src}
  )

TARGET_LINK_LIBRARIES(${TARGET} ${SDL2_LIBRARIES})
TARGET_LINK_LIBRARIES(${TARGET} rockbox_sys)
TARGET_LINK_LIBRARIES(${TARGET} rbcodec)
TARGET_LINK_LIBRARIES(${TARGET} tlsf)
TARGET_LINK_LIBRARIES(${TARGET} fixedpoint)
#TARGET_LINK_LIBRARIES(${TARGET} codecs)
