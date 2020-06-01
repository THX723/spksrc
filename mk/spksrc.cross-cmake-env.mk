# Configuration for cmake build
#
CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_EXE_LINKER_FLAGS=-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath-link,$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath,$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE

# set default build directory
ifeq ($(strip $(PKG_WORK_DIR)),)
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build
endif

# set path to assembler
NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

# Define GO_ARCH for go compiler
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
  CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=aarch64
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_C_FLAGS=-maltivec -DENABLE_ALTIVEC=OFF -DCPU_POWER8=OFF
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
  DEPENDS += native/nasm cross/libnuma
  ENV += PATH=$(NASM_PATH):$$PATH
  ENV += AS=$(NASM_PATH)/nasm
  CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86 -DARCH=32
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
  DEPENDS += native/nasm cross/libnuma
  ENV += PATH=$(NASM_PATH):$$PATH
  ENV += AS=$(NASM_PATH)/nasm
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DARCH=64
endif
