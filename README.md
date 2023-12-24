# HP-Elite-C1030-Hackintosh
Installing MacOS on the HP Elite C1030 Chromebook (Jinlon)

### ⚠️ Disclaimer
**By continuing, you acknowledge that you have read and understood the contents of the following disclaimer, and consent to their terms.**

**The process described in this guide may cause irreversible damage to your laptop. We accept absolutely no responsibility for the consequences of anyone electing to follow or ignore any of the instructions in this document, and make no guarantees about the quality or effectiveness of the software therein.**

**This guide is intended to be used on a self-service and reference basis only. It may become out of date or no longer updated at any time. It is up to you to find up to date information. NO SUPPORT WHATSOEVER will be given to those using preconfigued EFI's/Plists, configurators, patches or Clover. Follow the Acidathera Documentation.**

## Specifications
| Type | Model | Status |
|----------|----------|----------|
| Processor | Intel i3-10110U / i5-10310U / i7-10610U | Fully Supported |
| Graphics | Intel UHD 620 | Fully Supported |
| Memory | 8gb/16gb DDR4 | Fully Supported |
| Storage | Samsung PM991 MZ9LQ128HBJQ 128gb/256gb M.2 2230 (Replaceable) | Unsupported** |
| WiFi + Bluetooth | Intel Wi-Fi 6 AX201 / Bluetooth 5.2 | Fully Supported |
| WWAN | Intel XMM 7360 (Fibocom l850-gl) | Untested | 
| Touchscreen | 13.5" 1920 x 1280 I2CHID Goodix | Fully Supported |
| Touchpad | I2C ELAN | Fully Supported |
| Sound | Intel DSP SST HD Audio | Unsupported |
| Webcam | 720p HD webcam | Fully Supported |
| Fingerprint Reader | Unknown | Unsupported |

**OEM SSD's are not supported due to issues with the Samsung PM991 controller. It will not format to AFPS or MacOS Extended in recovery, let alone install MacOS. There are several online workarounds involving flashing from a seperate but none are particually stable or viable. It is HIGHLY suggested to replace your drive with a supported M.2 2230 drive. I used the Corsair MP600 Mini 1tb, which is popular with the Steam Deck crowd.

## Installation
### Preliminary

1. Flash Mr. Chromebox's [CoreBoot Firmware](https://mrchromebox.tech/).
3. Build the base OpenCore EFI for [Comet Lake Laptops](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html/).

### EFI Edits
#### ACPI
| SSDT | Notes | Link |
|----------|----------|----------|
| SSDT-ALS0 | Ambient Light Sensor Spoof | [Link](https://github.com/CeuiLiSA/Opencore-EFI/blob/master/EFI/OC/ACPI/SSDT-ALS0.aml)


#### Kexts
| Kext | Notes | Link |
|----------|----------|----------|
| Lilu | N/A | [Link](https://github.com/acidanthera/Lilu/releases)
| VirtualSMC | Do not use the included SMCLightSensor | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCBatteryManager | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCProcessor | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCSuperIO | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| VoodooI2C | N/A | [Link](https://github.com/VoodooI2C/VoodooI2C) |
| VoodooI2CHID | VoodooI2C Satalite for Touchscreen Support | [Link](https://github.com/VoodooI2C/VoodooI2C)
| VoodooPS2Controller | Custom fork that uses HID Codes over ADB | [Link](https://github.com/1Revenger1/VoodooPS2/releases) |

5. Map USB Devices [Guide](https://old.reddit.com/r/hackintosh/comments/ta1ef4/guide_easy_usb_mapping_with_usbtoolbox_on_windows/). This particualar guide seems to be the most useful. Having a working Windows install or knowledge of Windows PE is highly suggested. Don't forget to map the Wifi/BT and Webcam as internal!
