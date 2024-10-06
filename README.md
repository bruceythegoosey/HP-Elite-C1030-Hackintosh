# HP Elite C1030 Hackintosh
Installing MacOS on the HP Elite C1030 Chromebook (Jinlon)

### ⚠️ Disclaimer
**By continuing, you acknowledge that you have read and understood the contents of the following disclaimer, and consent to their terms.**

**The process described in this guide may cause irreversible damage to your laptop. We accept absolutely no responsibility for the consequences of anyone electing to follow or ignore any of the instructions in this document, and make no guarantees about the quality or effectiveness of the software therein.**

**This guide is intended to be used on a self-service and reference basis only. It may become out of date or no longer updated at any time. It is up to you to find up to date information. NO SUPPORT WHATSOEVER will be given to those using preconfigued EFI's/Plists, configurators, patches or Clover. Follow the Acidathera Documentation and/or the Dortania OpenCore Install Guide.**

## Tested Versions
1. macOS Sonoma (14.7)
2. macOS Sequoia (15.1)

At the time of writing, October 6th 2024, Sonoma is the highest reccomened OS to use. macOS Sequoia, still, is not officially supported by some of the kernel extensions used in our EFI, so therefore, it is not considered fully supported. You are on your own if you decide to install Sequoia. 

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
2. Build the base OpenCore EFI for [Comet Lake Laptops](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html/).

### EFI Edits

<hr>

### config.plist

A quick note: If you see something in the guide that says "HP Machines will require this quirk" or "Required by HP mothreboards", you can ignore them, as they are talking about regular HP laptops, that run Windows, and NOT Chromebooks. 

#### ACPI:
a. No extra changes are required here.

<hr>

#### Booter -> Quirks:
a. `DevirtualiseMimo` -> False

b. `ProtectMemoryReigons` -> True

Everything else remains the same for this section.

<hr>

#### Device Properties -> PciRoot(0x0)/Pci(0x2,0x0)
| Setting | Type | Value |
|----------|----------|----------|
| `AAPL,ig-platform-id`  | Data | `0900A53E` |
| `disable-telemetry-load` | Data | `01000000`
| `device-id` | Data | `9B3E0000` |
| `enable-backlight-smoothen` | Data | `01000000` |
| `enable-backlight-registers-alternative-fix` | Data | `01000000` |
| `rps-control` | Data | `01000000` |

<hr>

#### Misc -> Security
`SecureBootModel` -> `Disabled` DURING INSTALLATION ONLY, once done installing use `j223`

NOTE: This MUST be off during installation or it will fail. Once it is completed, you can change it to `j223`

<hr>

#### PlatformInfo -> Generic
a. Use `MacBookPro16,3` SMBIOS. Keep in mind the minimum macOS version for this SMBIOS is 10.15.4 (19E2265).

<hr>


### ACPI
Note: It is advised to generate your own SSDTs using SSDTTime, a tool provided by CorpNewt. Using SSDTs built specifically for your system ensures reliability and reduces the chance of random ACPI errors.


| SSDT | Notes | Link |
|----------|----------|----------|
| SSDT-ALS0 | Ambient Light Sensor Spoof | [Link](https://github.com/bruceythegoosey/HP-Elite-C1030-Hackintosh/blob/main/Resources/SSDT-ALS0.dsl)
| DMAR| Generally a good file to have | Made via SSDTTime 
| SSDT-ChromeKeysJinlon | Enables top row key functionallity | [Link](https://github.com/bruceythegoosey/HP-Elite-C1030-Hackintosh/blob/main/Resources/SSDT-ChromeKeysJinlon.dsl)
| SSDT-EC (Laptop Version) | EC SSDT, made via SSDTTime |  Made via SSDTTime
| SSDT-HPET | Patches out IRQ conflicts, made via SSDTTime |  Made via SSDTTime
| SSDT-PNLF | For proper screen backlight functioning, made via SSDTTime |  Made via SSDTTime
| SSDT-USBX | For proper USB support, made via SSDTTime |  Made via SSDTTime



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
1. Remove Verbose
2. Switch to Release edition of OpenCore (If using Debug)
3. Remove debug related values
4. Run these in terminal:
  
        sudo pmset autopoweroff 0
        sudo pmset powernap 0
        sudo pmset standby 0
        sudo pmset proximitywake 0
        sudo pmset tcpkeepalive 0

