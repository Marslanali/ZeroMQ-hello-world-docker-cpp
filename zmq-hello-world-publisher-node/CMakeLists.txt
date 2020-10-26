cmake_minimum_required(VERSION 3.15)
project(zmq_hello_world)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -pthread")

## load in pkg-config support
find_package(PkgConfig)
## use pkg-config to get hints for 0mq locations
pkg_check_modules(PC_ZeroMQ QUIET zmq)

# use the hint from above to find where 'zmq.hpp' is located
find_path(ZeroMQ_INCLUDE_DIR
        NAMES zmq.hpp
        PATHS ${PC_ZeroMQ_INCLUDE_DIRS}
        )

## use the hint from about to find the location of libzmq
find_library(ZeroMQ_LIBRARY
        NAMES zmq
        PATHS ${PC_ZeroMQ_LIBRARY_DIRS}
        )

set(SOURCE_FILES
        src/hwpublisher2.cpp)

add_executable(zmq_hello_world ${SOURCE_FILES} )

## add the include directory to our compile directives
target_include_directories(zmq_hello_world PUBLIC ${ZeroMQ_INCLUDE_DIR})
## at the 0mq library to our link directive
target_link_libraries(zmq_hello_world PUBLIC ${ZeroMQ_LIBRARY} libpthread.so.0)






#endif()


#find_package(Boost  REQUIRED COMPONENTS system filesystem)
#include_directories(${Boost_INCLUDE_DIRS})
#link_directories( ${Boost_LIBRARY_DIRS})

#set(BOOST_SYSTEM                "${BOOST_LATEST_BIN_DIR}/libboost_system.so")
#set(BOOST_FS                    "${BOOST_LATEST_BIN_DIR}/libboost_filesystem.so")
#set(BOOST_THREAD                "${BOOST_LATEST_BIN_DIR}/libboost_thread.so")
#find_package(Boost 1.2)
#if(Boost_FOUND)
#    include_directories(${Boost_INCLUDE_DIRS})


#link_directories(${Boost_LIBRARY_DIR})



