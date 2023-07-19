bambustudio_add_cmake_project(
    TBB
    URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.9.0.zip"
    URL_HASH SHA256=fcebb93cb9f7e882f62cd351b1c093dbefdcae04b616227dc716b0a5efa9e8ab
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


