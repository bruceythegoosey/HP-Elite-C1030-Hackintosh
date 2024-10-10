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
| Graphics | Intel UHD 620 | Fully Supported, requires iGPU spoof to UHD 630 |
| Memory | 8GB /16 GB DDR4 | Fully Supported |
| Storage | Various 128gb/256gb M.2 2230 SSDs (Replaceable) | Unsupported if you have Samsung PM991** |
| Storage Recommendation: | Any Western Digital 2230 SSD | All Western Digital SSDs are natively supported by macOS, though you will still need NVMeFix.kext for power management | 
| WiFi + Bluetooth | Intel Wi-Fi 6 AX201 / Bluetooth 5.2 | Fully Supported |
| WWAN | Intel XMM 7360 (Fibocom l850-gl) | Untested, available on specific models only. | 
| Touchscreen | 13.5" 1920 x 1280 I2CHID Goodix | Works, but broken in macOS, leave disabled. |
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

A quick note: If you see something in the guide that says "HP Machines will require this quirk" or "Required by HP mothreboards", you can **ignore** them, as they are talking about **regular HP laptops**, that run Windows, and **NOT** Chromebooks. 

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
Note: It is advised to generate your own SSDTs using SSDTTime, a tool provided by CorpNewt. Using SSDTs built specifically for your system ensures reliability and reduces the chance of random ACPI errors. You can compile decompile ACPI source code (.dsl file extension) by using iASL, which can be downloaded from Intel's website, click [here](https://www.intel.com/content/www/us/en/developer/topic-technology/open/acpica/download.html) (Scroll down and look for Windows Binary Tools). If you are on macOS, you can compile using MaciASL, click [here](https://github.com/acidanthera/MaciASL) for the link.


| SSDT | Notes | Link |
|----------|----------|----------|
| SSDT-ALS0 | Ambient Light Sensor Spoof, required for keyboard backlight functioning | [Link](https://github.com/bruceythegoosey/HP-Elite-C1030-Hackintosh/blob/main/Resources/SSDT-ALS0.dsl)
| DMAR| Generally a good file to have, removes reserved memory regions | Made via SSDTTime 
| SSDT-ChromeKeysJinlon | Enables top row key functionallity | [Link](https://github.com/bruceythegoosey/HP-Elite-C1030-Hackintosh/blob/main/Resources/SSDT-ChromeKeysJinlon.dsl)
| SSDT-EC (Laptop Version) | EC SSDT, made via SSDTTime |  Made via SSDTTime
| SSDT-HPET | Patches out IRQ conflicts, made via SSDTTime, choose C for defaults when making |  Made via SSDTTime
| SSDT-PNLF | For proper screen backlight functioning, made via SSDTTime, choose CFL/CML when making |  Made via SSDTTime
| SSDT-USBX (Laptop Version) | For proper USB support, made via SSDTTime |  Made via SSDTTime

<hr>

### Kexts
| Kext | Notes | Link |
|----------|----------|----------|
| Lilu | N/A | [Link](https://github.com/acidanthera/Lilu/releases)
| VirtualSMC | Do not use the included SMCLightSensor | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCBatteryManager | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCProcessor | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| SMCSuperIO | VirtualSMC Satalite | [Link](https://github.com/acidanthera/VirtualSMC/releases) |
| VoodooI2C | N/A | [Link](https://github.com/VoodooI2C/VoodooI2C) |
| VoodooPS2Controller | Custom fork that uses HID Codes over ADB | [Link](https://github.com/1Revenger1/VoodooPS2/releases) |
| BlueToolFixup | Required for macOS Monterey (12) and up. | [Link](https://github.com/acidanthera/BrcmPatchRAM/)
| CrosEC | Chromebook EC kernel extension | [Link](https://github.com/Chromeintosh/CrosEC/)
| IntelBluetoothFirmware | Make sure you install the right kexts | [Link](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/)
| itlwm | Use itlwm + HeliPort for functional iServices on Sonoma and above, otherwise use AirportItlwm | [Link](https://github.com/OpenIntelWireless/itlwm)
| NVMeFix | n/a | [Link](https://github.com/acidanthera/NVMeFix)
| USBToolBox | Follow the directions for the mapping guide | [Link](https://github.com/USBToolBox/kext)
| UTBMap | Follow the directions for the mapping guide (same as above) | [Link](https://github.com/USBToolBox/tool) 

5. Map USB Devices [Guide](https://old.reddit.com/r/hackintosh/comments/ta1ef4/guide_easy_usb_mapping_with_usbtoolbox_on_windows/). This particualar guide seems to be the most useful. Having a working Windows install or knowledge of Windows PE is highly suggested. Don't forget to map the Wifi/BT and Webcam as internal (255)!

    - Make sure you plug in both USB 2.0 and 3.0 devices, as they are NOT the same. If your USB 2.0 ports are not identified in the USB map, they will not be recognized in macOS. 

<hr>

### Drivers
The default configuration provided by Dortania's OpenCore Install Guide are sufficient for proper functioning. So,

| Driver | Notes | 
| -------| ------|
| OpenRuntime | Required for macOS 
| HfsPlus | Required for macOS
| ResetNvramEntry | Not required to boot macOS, but HIGHLY reccomend having this in your EFI, as you will need to reset NVRAM at least once.


<hr>

### Resources and Tools
Nothing from these folders are required in order to boot macOS.

<hr>

## Installation:

### Prerequisites
At this point, your EFI should be completed, and everything shoud be good to go. Generally, it's good practice to review your EFI one more time, especially your kernel extensions ACPI folder, and your config.plist. 

You should have:

1. Your USB drive, formatted in FAT32 with nothing in it
2. Your EFI 
3. Your `com.apple.recovery.boot` folder, or your offline macOS installer 
4. Your Chromebook
5. A charger, preferrably 

<hr>

### Booting the USB
1. Ideally, power cycle your Chromebook a few times, to prevent anty hardware issues and to idiot proof this install. Hold the Refresh button (F2), and press the power button on the side of your laptop a few times.
2. Boot the laptop
3. Press ESC when you see the Coreboot logo
4. Boot your USB with your EFI.
5. Once you are in OpenCore, press your spacebar, then select Reset NVRAM. Your laptop should reboot.
6. Boot into your OpenCore USB again, and press space when it loads
7. Select your USB drive's name. It should have (external), or (dmg) in the name as well.
8. If it freezes, do not restart. If you are on the debug version of OpenCore, booting will take significantly longer than usual.
9. Once you are in the macOS installer, you're good!

<hr>

### Installation
1. Connect to internet. If you are using AirportItlwn, this should be simple enough.
    - If you're using itlwm, you'll need to specify your WiFi credentials in the kernel extension itself. (Contents -> Info.plist)
        - Root -> IOKitPersonalities -> itlwm -> WiFiConfig 
            - WiFi_1 is network 1, etc etc. The SSID is the network name, the password is your WiFi password.
2. Open Disk Utility, and click View, then Show ALl Volumes.
3. Select your SSD, then click Erase.
    - **Warning:** This action will erase all of your data on the SSD. It will render the system un-bootable until macOS installs sucessfully.
4. Format the disk as APFS, with a GUID Partition Table (GPT)
5. Exit Disk Utility, then begin the macOS install. It will reboot a few times.
    - When it reboots, coreboot will say that your SSD does not contain a bootable 64 bit OS. Do not panic. Press any key to continue, and when it puts you in the shell, type exit. Then, boot your OpenCore USB again to continue. 
    - After the first reboot, you will have the option to boot into `macOS Installer`. Select this option to continue the rest of the install. 
    - It will reboot around 2 more times, continue to boot into `macOS Installer` in OpenCore. 
    - Eventually, the install will complete, and the name of your SSD will pop up instead. When this happens, you are safe to select that option. 
6. After the many reboots, it will land you in the macOS setup! Congrats!

<hr>

### macOS Setup 
1. Follow the instructions on screen
2. Do NOT sign into iCloud when prompted, do that after your Post Install to minimize the risk of getting your Apple ID blacklisted.



## Post Install
1. Remove Verbose
2. Switch to Release edition of OpenCore (If using Debug)
3. Remove debug related values
4. Copy your EFI to your SSD
5. Run these in terminal:
  
        sudo pmset autopoweroff 0
        sudo pmset powernap 0
        sudo pmset standby 0
        sudo pmset proximitywake 0
        sudo pmset tcpkeepalive 0

6. Use ProperTree to strip disabled entries and comments in your config.plist.
7. Hide the OpenCore boot menu by disabling `ShowPicker` in your config.plist.
    - Should you need it again, you can press `ESC` after the coreboot logo ends and before the Apple logo displays to bring the menu up.
8. Sign into iServices if you want to
    - If you are on macOS Sonoma or higher, you will need to use itlwm and Heliport to have functional iServices. Otherwise, you can ignore this.


## Tips 

TODO: ectool, display rotation, 


<br>
Thats it, enjoy!
