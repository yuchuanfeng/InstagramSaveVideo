THEOS_DEVICE_IP = 192.168.x.xxx
ARCHS = arm64
TARGET = iphone:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 09InstagramSaveMedia
09InstagramSaveMedia_FILES = Tweak.xm
# 09InstagramSaveMedia_FILES += ./Headers/choose.mm
09InstagramSaveMedia_FILES += ./Headers/InstagramTweakTool.m
09InstagramSaveMedia_FILES += ./Headers/YQAssetOperator.m

# export ADDITIONAL_CCFLAGS  = -std=c++11

09InstagramSaveMedia_FRAMEWORKS = UIKit


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
