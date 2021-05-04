export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = SignalReborn

SignalReborn_CODESIGN_FLAGS = -SSignalEntitlements.xml
SignalReborn_XCODE_SCHEME = Signal

include $(THEOS_MAKE_PATH)/xcodeproj.mk

after-install::
	install.exec 'uicache -p /Applications/Signal.app'
