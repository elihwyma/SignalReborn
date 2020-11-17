export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.3:11.0
# export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

#DEBUG = 0
#FINALPACKAGE = 1
#PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk
SUBPROJECTS += src/Signal-App
include $(THEOS_MAKE_PATH)/aggregate.mk
