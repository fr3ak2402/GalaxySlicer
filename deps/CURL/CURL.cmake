
# Use Curl 7.75.0 for Windows
if (WIN32)
	set(_curl_url "https://github.com/curl/curl/archive/refs/tags/curl-7_75_0.zip")
	set(_curl_hash a63ae025bb0a14f119e73250f2c923f4bf89aa93b8d4fafa4a9f5353a96a765a)
else()
	#set(_curl_url "https://github.com/curl/curl/releases/download/curl-8_2_0/curl-8.2.0.zip")
	#set(_curl_hash 3f36ff8e8eb780a9e1400309a1f813f260399baa93c2fc8ac0c389e2161c5098)
	
	set(_curl_url "https://github.com/curl/curl/archive/refs/tags/curl-7_75_0.zip")
	set(_curl_hash a63ae025bb0a14f119e73250f2c923f4bf89aa93b8d4fafa4a9f5353a96a765a)
endif()

# Set Curl Platform Flags
set(_curl_platform_flags 
  -DENABLE_IPV6:BOOL=ON
  -DENABLE_VERSIONED_SYMBOLS:BOOL=ON
  -DENABLE_THREADED_RESOLVER:BOOL=ON
  -DENABLE_MANUAL:BOOL=OFF
  -DCURL_DISABLE_LDAP:BOOL=ON
  -DCURL_DISABLE_LDAPS:BOOL=ON
  -DCURL_DISABLE_RTSP:BOOL=ON
  -DCURL_DISABLE_DICT:BOOL=ON
  -DCURL_DISABLE_TELNET:BOOL=ON
  -DCURL_DISABLE_POP3:BOOL=ON
  -DCURL_DISABLE_IMAP:BOOL=ON
  -DCURL_DISABLE_SMB:BOOL=ON
  -DCURL_DISABLE_SMTP:BOOL=ON
  -DCURL_DISABLE_GOPHER:BOOL=ON
  -DCURL_DISABLE_TFTP:BOOL=ON
  -DCURL_DISABLE_MQTT:BOOL=ON
  #-DHTTP_ONLY=ON

  -DCMAKE_USE_GSSAPI:BOOL=OFF
  -DCMAKE_USE_LIBSSH2:BOOL=OFF
  -DUSE_RTMP:BOOL=OFF
  -DUSE_NGHTTP2:BOOL=OFF
  -DUSE_MBEDTLS:BOOL=OFF
)

if (WIN32)
  set(_curl_platform_flags  ${_curl_platform_flags} -DCMAKE_USE_SCHANNEL=ON)
elseif (APPLE)
  set(_curl_platform_flags 
    
    ${_curl_platform_flags}

    #-DCMAKE_USE_SECTRANSP:BOOL=ON 
    -DCMAKE_USE_OPENSSL:BOOL=ON

    -DCURL_CA_PATH:STRING=none
  )
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(_curl_platform_flags 

    ${_curl_platform_flags}

    -DCMAKE_USE_OPENSSL:BOOL=ON

    -DCURL_CA_PATH:STRING=none
    -DCURL_CA_BUNDLE:STRING=none
    -DCURL_CA_FALLBACK:BOOL=ON
  )
endif ()

if (BUILD_SHARED_LIBS)
  set(_curl_static OFF)
else()
  set(_curl_static ON)
endif()

bambustudio_add_cmake_project(CURL
  # GIT_REPOSITORY      https://github.com/curl/curl.git
  # GIT_TAG             curl-7_75_0
  URL                 ${_curl_url}
  URL_HASH            SHA256=${_curl_hash}
  DEPENDS             ${ZLIB_PKG}
  # PATCH_COMMAND       ${GIT_EXECUTABLE} checkout -f -- . && git clean -df && 
  #                     ${GIT_EXECUTABLE} apply --whitespace=fix ${CMAKE_CURRENT_LIST_DIR}/curl-mods.patch
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_CURL_EXE:BOOL=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    -DCURL_STATICLIB=${_curl_static}
    ${_curl_platform_flags}
)

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  add_dependencies(dep_CURL dep_OpenSSL)
endif ()

if (MSVC)
    add_debug_dep(dep_CURL)
endif ()
