# HP Elite C1030 Hackintosh
Installing MacOS on the HP Elite C1030 Chromebook (Jinlon)

### ⚠️ Disclaimer
**By continuing, you acknowledge that you have read and understood the contents of the following disclaimer, and consent to their terms.**

**The process described in this guide may cause irreversible damage to your laptop. We accept absolutely no responsibility for the consequences of anyone electing to follow or ignore any of the instructions in this document, and make no guarantees about the quality or effectiveness of the software therein.**

**This guide is intended to be used on a self-service and reference basis only. It may become out of date or no longer updated at any time. It is up to you to find up to date information. NO SUPPORT WHATSOEVER will be given to those using preconfigued EFI's/Plists, configurators, patches or Clover. Follow the Acidathera Documentation and/or the Dortania OpenCore Install Guide.**

## Specifications
| Type | Model | Status |
|----------|----------|----------|
| Processor | Intel i3-10110U / i5-10310U / i7-10610U | Fully Supported |
| Graphics | Intel UHD 620 | Fully Supported |
| Memory | 8gb/16gb DDR4 | Fully Supported |
| Storage | Various 128gb/256gb M.2 2230 SSDs (Replaceable) | Unsupported if you have Samsung PM991** |
| WiFi + Bluetooth | Intel Wi-Fi 6 AX201 / Bluetooth 5.2 | Fully Supported |
| WWAN | Intel XMM 7360 (Fibocom l850-gl) | Untested | 
| Touchscreen | 13.5" 1920 x 1280 I2CHID Goodix | Broken in macOS, leave disabled. |
| Touchpad | I2C ELAN | Fully Supported |
| Sound | Intel DSP SST HD Audio | Unsupported |
| Webcam | 720p HD webcam | Fully Supported |
| Fingerprint Reader | Unknown | Unsupported |

**This machine has several different SSD OEMs, ranging from Samsung to WD. **Please check your SSD model before proceeding.** If you have a WD model, you are good to go. If you end up with the Samsung PM991 SSD, you will need to replace it.

## Installation
### Preliminary

1. Flash the Chromeintosh coreboot build. [GitHub Repo](https://github.com/Chromeintosh/coreboot)
  a. `cd; curl -LJOk https://ethanthesleepy.one/macos/firmware-util.sh; chmod +x firmware-util.sh; sudo bash ./firmware-util.sh`
3. Build the base OpenCore EFI for [Comet Lake Laptops](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html/).

### EFI Edits

#### config.plist
1. `DevirtualiseMimo` -> False
2. `ProtectMemoryReigons` True
3. `enable-backlight-smoothen` | Data | `01000000`
4. `enable-backlight-registers-alternative-fix` | Data | `01000000`
5. `rps-control` | Data | `01000000`
6. `SecureBootModel` -> `Disabled` DURING INSTALLATION


#### ACPI
Note: It is advised to generate your own SSDTs using SSDTTime, a tool provided by CorpNewt. Using SSDTs built specifically for your system ensures reliability and reduces the chance of random ACPI errors.

// ToDo: Link our own ALS0 SSDT here, DMAR, ADB maps, which SSDTs to use

| SSDT | Notes | Link |
|----------|----------|----------|
| SSDT-ALS0 | Ambient Light Sensor Spoof | [Link](https://github.com/CeuiLiSA/Opencore-EFI/blob/master/EFI/OC/ACPI/SSDT-ALS0.aml)
| DMAR| Generally a good file to have | Made via SSDTTime 
| SSDT-ChromeKeysJinlon | Enables top row key functionallity | [Link]()
| SSDT-EC | EC SSDT, made via SSDTTime | n/a
| SSDT-HPET | Patches out IRQ conflicts, made via SSDTTime | n/a
| SSDT-PNLF | For proper screen backlight functioning, made via SSDTTime | n/a
| SSDT-USBX | For proper USB support, made via SSDTTime | n/a



#### Kexts
| Kext | Notes | Link |
|----------|----------|----------|
| Lilu | N/A | [Link](https://github.com/acidanthera/Lilu/releases)
| VirtualSMC | Do not use the included SMCLightSensor | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCBatteryManager | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCProcessor | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCSuperIO | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| VoodooI2C | N/A | [Link](https://github.com/VoodooI2C/VoodooI2C) |
| VoodooPS2Controller | Custom fork that uses HID Codes over ADB | [Link](https://github.com/1Revenger1/VoodooPS2/releases) |
| BlueToolFixup | Required for macOS Monterey (12) and up. | 
| CrosEC | Chromebook EC kernel extension |
| IntelBluetoothFirmware | Make sure you install the right kexts |
| itlwm | Use itlwm + HeliPort for functional iServices on Sonoma and above, otherwise use AirportItlwm |
| NVMeFix | n/a | 
| USBToolBox | Follow the directions for the mapping guide
| UTBMap | Follow the directions for the mapping guide (same as above)

5. Map USB Devices [Guide](https://old.reddit.com/r/hackintosh/comments/ta1ef4/guide_easy_usb_mapping_with_usbtoolbox_on_windows/). This particualar guide seems to be the most useful. Having a working Windows install or knowledge of Windows PE is highly suggested. Don't forget to map the Wifi/BT and Webcam as internal (255)!

#### Drivers
The default configuration provided by Dortania's OpenCore Install Guide are sufficient for proper functioning. So,
1. OpenRuntime
2. HfsPlus
3. ResetNvramEntry



## Post Install
(todo)
