cmake_minimum_required(VERSION 3.27)
project(sdl2_metal VERSION 0.0.1 LANGUAGES C CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_STANDARD 17)

file(GLOB_RECURSE FILE_SOURCES RELATIVE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.mm
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
)

add_definitions("-x objective-c++")
find_library(COCOA_LIBRARY Cocoa)
find_library(QUARTZ_LIBRARY QuartzCore)
find_library(METAL_LIBRARY Metal)
find_package(SDL2 REQUIRED)

add_executable(${PROJECT_NAME} ${FILE_SOURCES})
target_link_libraries(${PROJECT_NAME} SDL2::SDL2main SDL2::SDL2 ${COCOA_LIBRARY} ${QUARTZ_LIBRARY} ${METAL_LIBRARY})
