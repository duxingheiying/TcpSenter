#set(CMAKE_PREFIX_PATH D:/Qt/5.15.2/msvc2019_64/lib/cmake/Qt${QT_VERSION_MAJOR}/)

set(CMAKE_DEBUG_POSTFIX "d")
#set(CMAKE_RELEASE_POSTFIX "_r") 
set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/libs/)

include (${CMAKE_CURRENT_SOURCE_DIR}/cmake/qt_setup_install.cmake)

include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/)

#set(EXECUTABLE_OUTPUT_PATH path)

set(CMAKE_AUTOMOC ON) # auto create moc file
set(CMAKE_AUTORCC ON) # auto create rcc file
set(CMAKE_AUTOUIC ON) # auto create uic file

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets Concurrent Network REQUIRED) # find qt library

file(GLOB_RECURSE SOURCECODE ${CMAKE_CURRENT_LIST_DIR}/*.h
    ${CMAKE_CURRENT_LIST_DIR}/*.cpp
    ${CMAKE_CURRENT_LIST_DIR}/*.rc
    ${CMAKE_CURRENT_LIST_DIR}/*.qrc)

add_executable(${PROJECT_NAME} ${SOURCECODE})

target_link_libraries(${PROJECT_NAME} PRIVATE 
Qt${QT_VERSION_MAJOR}::Widgets 
Qt${QT_VERSION_MAJOR}::Concurrent
Qt${QT_VERSION_MAJOR}::Network
) # add library

windeployqt(${PROJECT_NAME})

#qt_add_translations(${PROJECT_NAME} TS_FILES zh_CN.ts)