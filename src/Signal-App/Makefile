export ARCHS = arm64 arm64e
#export THEOS_DEVICE_IP=192.168.0.85
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = SignalReborn

SignalReborn_CODESIGN_FLAGS = -SSignalEntitlements.xml
#SignalReborn_XCODE_SCHEME = Jailed

include $(THEOS_MAKE_PATH)/xcodeproj.mk

after-install::
	install.exec 'uicache -p /Applications/SignalReborn.app'
