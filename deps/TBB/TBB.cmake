
# Use oneTBB v2021.10.0 for Windows and macOS to fully support hybrid CPUs.
if (WIN32)
	set(_oneTBB_url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.10.0.zip")
	set(_oneTBB_hash 78fb7bb29b415f53de21a68c4fdf97de8ae035090d9ee9caa221e32c6e79567c)
else()
	set(_oneTBB_url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.10.0.zip")
	set(_oneTBB_hash 78fb7bb29b415f53de21a68c4fdf97de8ae035090d9ee9caa221e32c6e79567c)
endif()

bambustudio_add_cmake_project(
    TBB
    URL ${_oneTBB_url}
    URL_HASH SHA256=${_oneTBB_hash}
    #PATCH_COMMAND ${PATCH_CMD} ${CMAKE_CURRENT_LIST_DIR}/0001-TBB-GCC13.patch
    CMAKE_ARGS          
        -DTBB_BUILD_SHARED=OFF
        -DTBB_BUILD_TESTS=OFF
        -DTBB_TEST=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_DEBUG_POSTFIX=_debug
)

if (MSVC)
    add_debug_dep(dep_TBB)
endif ()


