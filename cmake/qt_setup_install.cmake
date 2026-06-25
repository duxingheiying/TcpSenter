# define Qt base path
set(QT_VERSION_MAJOR 6)

SET(QT_INSTALL_PATH "QT_INSTALL_PATH-NOTFOUND" CACHE PATH "QT_INSTALL_PATH")
if(DEFINED ENV{QT_INSTALL_PATH})
    message("SYS QT_INSTALL_PATH :  $ENV{QT_INSTALL_PATH}")
    set(qt_install_path_temp $ENV{QT_INSTALL_PATH})
    string(REPLACE "\\" "/"  QT_INSTALL_PATH ${qt_install_path_temp}) # replace \ into /
else()
    set(QT_INSTALL_PATH D:/Qt/6.5.3/msvc2019_64)
    message("SET QT_INSTALL_PATH :  ${QT_INSTALL_PATH}")
endif()
#set(QT_INSTALL_PATH D:/Qt/5.15.2/msvc2019_64)

set(CMAKE_PREFIX_PATH ${QT_INSTALL_PATH}) # set prefix path, qt install path
set(QT_CMAKE_PATH ${QT_INSTALL_PATH}/lib/cmake)
set(ADS_LIBS "${CMAKE_CURRENT_SOURCE_DIR}/Depends/Ads")

message("QT_VERSION_MAJOR :  ${QT_VERSION_MAJOR}")

set(QT_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR})
set(Qt${QT_VERSION_MAJOR}_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR})
set(Qt${QT_VERSION_MAJOR}CoreTools_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}CoreTools)
set(Qt${QT_VERSION_MAJOR}Core_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}Core)
set(Qt${QT_VERSION_MAJOR}EntryPointPrivate_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}EntryPointPrivate)
set(Qt${QT_VERSION_MAJOR}GuiTools_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}GuiTools)
set(Qt${QT_VERSION_MAJOR}Gui_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}Gui)
set(Qt${QT_VERSION_MAJOR}WidgetsTools_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}WidgetsTools)
set(Qt${QT_VERSION_MAJOR}Widgets_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}Widgets)
set(Qt${QT_VERSION_MAJOR}PrintSupport_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}PrintSupport)
set(Qt${QT_VERSION_MAJOR}core5Compat_DIR ${QT_CMAKE_PATH}/Qt${QT_VERSION_MAJOR}core5Compat)

# add Qt private inter face
# begin add Qt private interface
set(QT_PRIVATE_DIRS "")
MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${curdir}/${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(QtPrivateSubDir ${QT_INSTALL_PATH}/include)

foreach(QtTypeDir ${QtPrivateSubDir} )
    SUBDIRLIST(QtTypeDirList ${QtTypeDir})
    foreach(privae_dir ${QtTypeDirList})
        LIST(APPEND QT_PRIVATE_DIRS ${privae_dir})
#        include_directories(${privae_dir})
    endforeach()
endforeach()
#end add Qt private interface


function(windeployqt target)
    # POST_BUILD step
    # - after build, we have a bin/lib for analyzing qt dependencies
    # - we run windeployqt on target and deploy Qt libs
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND "${QT_INSTALL_PATH}/bin/windeployqt.exe"
#        --verbose 1
#        --debug
#        --no-svg
#        --no-angle
#        --no-opengl
#        --no-opengl-sw
#        --no-compiler-runtime
#        --no-system-d3d-compiler
        \"$<TARGET_FILE:${target}>\"
        COMMENT "Deploying Qt libraries using windeployqt for compilation target '${target}' ..."
        )
endfunction()

#function(windeployqt TARGET)
#    install(CODE 
#        include(\"${QT_DEPLOY_SUPPORT}\")
#        set(QT_DEPLOY_BIN_DIR ${CMAKE_INSTALL_BINDIR})
#        execute_process(
#            COMMAND_ECHO STDOUT
#            COMMAND \"${WINDEPLOYQT_EXECUTABLE}\"
#            \"--dir=.\"
#            \"--plugindir=\${QT_DEPLOY_PLUGINS_DIR}\"
#            \"--no-quick-import\"
#            \"--no-translations\"
#            \"--no-system-d3d-compiler\"
#            \"--no-opengl-sw\"
#            \"\${QT_DEPLOY_BIN_DIR}/$<TARGET_FILE_NAME:${TARGET}>\"
#            WORKING_DIRECTORY \"\${QT_DEPLOY_PREFIX}\"
#        )
#    )
#endfunction()
#windeployqt(testcmakelist)


#if(TARGET Qt6::windeployqt)
     # execute windeployqt in a tmp directory after build
 #   add_custom_command(TARGET ${PROJECT_NAME}
#        POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E remove_directory "${CMAKE_CURRENT_BINARY_DIR}/windeployqt"
#        COMMAND set PATH=%PATH%$<SEMICOLON>${QT_INSTALL_PATH}/bin
#        COMMAND Qt6::windeployqt --dir "${CMAKE_CURRENT_BINARY_DIR}/windeployqt" "$<TARGET_FILE_DIR:${CMAKE_CURRENT_BINARY_DIR}>/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
#    )
    # copy deployment directory during installation
   # install(
   #     DIRECTORY
   #     "${CMAKE_CURRENT_BINARY_DIR}/windeployqt/"
   #     DESTINATION ${FOO_INSTALL_RUNTIME_DESTINATION}
   # )
#endif()

#if(EXISTS "${QT_INSTALL_PATH}/plugins/platforms/qwindows${DEBUG_SUFFIX}.dll")
#        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD 
#        COMMAND ${CMAKE_COMMAND} -E make_directory 
#        "$<TARGET_FILE_DIR:${PROJECT_NAME}>/platforms/"
#        )

#        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy
#        "${QT_INSTALL_PATH}/plugins/platforms/qwindows${DEBUG_SUFFIX}.dll" 
#        "${QT_INSTALL_PATH}/plugins/platforms/qdirect2d${DEBUG_SUFFIX}.dll"
#        "$<TARGET_FILE_DIR:${PROJECT_NAME}>/platforms/"
#        )
#endif()

#add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Qt6::Core> $<TARGET_FILE:Qt6::Gui> $<TARGET_FILE:Qt6::Widgets>  $<TARGET_FILE_DIR:${PROJECT_NAME}>)