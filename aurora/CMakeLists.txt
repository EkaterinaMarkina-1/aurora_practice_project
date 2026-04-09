cmake_minimum_required(VERSION 3.10)
project(aurora_flutter_app LANGUAGES CXX C)

set(BINARY_NAME ${CMAKE_PROJECT_NAME})
set(FLUTTER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/flutter)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_SKIP_RPATH OFF)
set(CMAKE_INSTALL_RPATH "\$ORIGIN/../share/${BINARY_NAME}/lib")

find_package(PkgConfig REQUIRED)
pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)

add_executable(${BINARY_NAME}
    main.cpp
    ${FLUTTER_DIR}/generated_plugin_registrant.cpp
)

target_include_directories(${BINARY_NAME} PRIVATE
    ${FLUTTER_DIR}
)

target_link_libraries(${BINARY_NAME} PRIVATE
    PkgConfig::FlutterEmbedder
)

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    /usr/lib/libflutter-embedder.so
    ${PROJECT_BINARY_DIR}/bundle/lib/libflutter-embedder.so
)


install(FILES ${PROJECT_BINARY_DIR}/bundle/icudtl.dat
        DESTINATION share/${BINARY_NAME})

install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/flutter_assets
        DESTINATION share/${BINARY_NAME})

install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/lib
        DESTINATION share/${BINARY_NAME})

install(TARGETS ${BINARY_NAME}
        RUNTIME DESTINATION bin)


install(FILES desktop/com.example.aurora_practice_project.desktop
        RENAME ${BINARY_NAME}.desktop
        DESTINATION share/applications)

foreach(ICONS_SIZE 86x86 108x108 128x128 172x172)
    install(FILES icons/${ICONS_SIZE}.png
            RENAME ${BINARY_NAME}.png
            DESTINATION share/icons/hicolor/${ICONS_SIZE}/apps/)
endforeach()
