cmake_minimum_required(VERSION 3.10)

project(aurora_flutter_app LANGUAGES CXX C)

# ========================
# Настройки проекта
# ========================
set(BINARY_NAME ${CMAKE_PROJECT_NAME})
set(FLUTTER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/flutter)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_SKIP_RPATH OFF)
set(CMAKE_INSTALL_RPATH "\$ORIGIN/../share/${BINARY_NAME}/lib")

# ========================
# Flutter Embedder
# ========================
find_package(PkgConfig REQUIRED)
pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)

# ========================
# Создаем исполняемый файл
# ========================
add_executable(${BINARY_NAME} 
    main.cpp 
    ${FLUTTER_DIR}/generated_plugin_registrant.cpp
)

target_include_directories(${BINARY_NAME} PRIVATE ${FLUTTER_DIR})
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::FlutterEmbedder)

# ========================
# Копируем libflutter-embedder.so в bundle
# ========================
add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/bundle/lib
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/libflutter-embedder.so
        ${PROJECT_BINARY_DIR}/bundle/lib/libflutter-embedder.so
)

# ========================
# Установка файлов для пакета
# ========================

# Папка для данных пакета
set(PACKAGE_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/${BINARY_NAME}) # /usr/share/aurora_flutter_app

# .desktop файл
set(DESKTOP_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/applications)   # /usr/share/applications

# Иконки
set(ICONS_INSTALL_ROOT_DIR ${CMAKE_INSTALL_DATADIR}/icons/hicolor) # /usr/share/icons/hicolor

# Копируем flutter_assets и lib
install(FILES ${PROJECT_BINARY_DIR}/bundle/icudtl.dat DESTINATION ${PACKAGE_INSTALL_DIR})
install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/flutter_assets DESTINATION ${PACKAGE_INSTALL_DIR})
install(DIRECTORY ${PROJECT_BINARY_DIR}/bundle/lib DESTINATION ${PACKAGE_INSTALL_DIR})

# Установка бинарника
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}) # /usr/bin

# Установка .desktop файла с переименованием
install(FILES desktop/com.example.aurora_practice_project.desktop
        RENAME ${BINARY_NAME}.desktop
        DESTINATION ${DESKTOP_INSTALL_DIR})

# Установка иконок
foreach(ICONS_SIZE 86x86 108x108 128x128 172x172)
    install(FILES icons/${ICONS_SIZE}.png 
            RENAME ${BINARY_NAME}.png 
            DESTINATION ${ICONS_INSTALL_ROOT_DIR}/${ICONS_SIZE}/apps/)
endforeach()
