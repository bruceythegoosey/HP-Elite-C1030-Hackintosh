DefinitionBlock ("", "SSDT", 2, "SOOT", "C1030", 0x00000000)
{
    External (_SB_.PCI0.PS2K, DeviceObj)

    Scope (\_SB.PCI0.PS2K)
    {
        Name (RMCF, Package (0x02)
        {
            "Keyboard", 
            Package (0x04)
            {
                "Swap command and option", 
                ">y", 
                "Custom ADB Map", 
                Package (0x0C)
                {
                    Package (0x00){}, 
                    "e06a=000c0224", 
                    "e067=000c0227", 
                    "e011=ff010001", 
                    "e012=ff010010", 
                    "e013=ff0F0001", 
                    "e014=00ff0005", 
                    "e015=00ff0004", 
                    "e017=00ff0009", 
                    "e018=00ff0008", 
                    "e01a=000c00cd", 
                    "5d=000c0039"
                }
            }
        })
    }
}

