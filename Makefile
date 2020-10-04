ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = SignalReborn

SignalReborn_CODESIGN_FLAGS = -SSignalEntitlements.xml

include $(THEOS_MAKE_PATH)/xcodeproj.mk

after-install::
	install.exec 'uicache -p /Applications/SignalReborn.app'