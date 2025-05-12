cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

# Automatically determine the project name from the current source directory name
get_filename_component(PROJ_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
project(${PROJ_NAME})

# Find Geant4 package, activating all available UI and Vis drivers by default
option(WITH_GEANT4_UIVIS "Build example with Geant4 UI and Vis drivers" ON)
if(WITH_GEANT4_UIVIS)
    find_package(Geant4 REQUIRED ui_all vis_all)
else()
    find_package(Geant4 REQUIRED)
endif()

# Setup Geant4 include directories and compile definitions
include(${Geant4_USE_FILE})
include_directories(${PROJECT_SOURCE_DIR}/include)

# Locate sources and headers for this project
file(GLOB sources ${PROJECT_SOURCE_DIR}/src/*.cc)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.hh)

# Automatically find the main .cc file in the project root directory
file(GLOB main_file ${PROJECT_SOURCE_DIR}/*.cc)
list(FILTER main_file EXCLUDE REGEX ".*/src/.*") # Exclude files in src folder
if(main_file)
    list(GET main_file 0 MAIN_SOURCE) # Take the first .cc file found
else()
    message(FATAL_ERROR "No main .cc file found in project root directory!")
endif()

# Create the executable using the auto-determined project name
add_executable(${PROJECT_NAME} ${MAIN_SOURCE} ${sources} ${headers})
target_link_libraries(${PROJECT_NAME} ${Geant4_LIBRARIES})

# Copy all scripts to the build directory
set(EXAMPLEED_SCRIPTS
        init_vis.mac
        run.mac
        run.png
        vis.mac
)

foreach(_script ${EXAMPLEED_SCRIPTS})
    configure_file(
            ${PROJECT_SOURCE_DIR}/${_script}
            ${PROJECT_BINARY_DIR}/${_script}
            COPYONLY
    )
endforeach()

# For internal Geant4 use
add_custom_target(ED DEPENDS ${PROJECT_NAME})

# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
install(TARGETS ${PROJECT_NAME} DESTINATION bin)