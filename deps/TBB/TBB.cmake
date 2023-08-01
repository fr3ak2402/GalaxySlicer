bambustudio_add_cmake_project(
    TBB
    URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.10.0.zip"
    URL_HASH SHA256=78fb7bb29b415f53de21a68c4fdf97de8ae035090d9ee9caa221e32c6e79567c
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


