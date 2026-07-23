cmake_minimum_required(VERSION 3.10)
project(power-menu VERSION 1.0.0 LANGUAGES C)

# 设置C标准
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 查找GTK3库
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

# 设置包含目录
include_directories(${GTK3_INCLUDE_DIRS})

# 添加可执行文件
add_executable(power-menu src/power-menu.c)

# 链接库
target_link_libraries(power-menu ${GTK3_LIBRARIES})