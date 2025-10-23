# The Jukebox Automation Project

> [!WARNING]
> This project is under development and currently largely untested.
> It is being documented as if finished but may be revised before the project is complete.
> You are advised not to use this project until this warning is removed

## Bringing Vintage Jukeboxes into the Streaming Age

The classic jukebox—once the centerpiece of diners and bars across America during its 1950s heyday—has found new life as a striking statement piece in modern homes. These beautiful electro-mechanical marvels, with their chrome accents, colorful lighting, and satisfying mechanical selections, combine nostalgia with undeniable visual appeal. Whether it's a gleaming Wurlitzer or a sleek Seeburg, vintage jukeboxes capture an era when choosing music was a tactile, social experience.

Today's jukebox market has split into two distinct worlds. Modern digital jukeboxes offer impressive features: massive music libraries accessed through streaming services, customizable playlists, shuffle and repeat modes, and even smartphone connectivity. Meanwhile, vintage electro-mechanical jukeboxes—the ones with genuine aesthetic and historical value—remain limited to their original 45 RPM records, manual song selection, and a fixed repertoire of perhaps 100 tracks at most.

For collectors and enthusiasts who've invested in these vintage machines, this creates a frustrating dilemma: sacrifice the authentic look and feel of a classic jukebox for modern convenience, or maintain the vintage aesthetic while accepting severe functional limitations.

This project bridges that gap. By retrofitting electro-mechanical jukeboxes with modern automation capabilities, we can preserve the iconic appearance and mechanical operation while adding features that today's users expect: continuous autoplay, curated playlists, access to streaming services like Spotify, and automated selection — all while maintaining the jukebox's original visual charm and mechanical character. The result is the best of both worlds: a stunning vintage centerpiece that sounds and functions like it belongs in the 21st century.

## Technical Approach 

The retrofit centers on integrating a Raspberry Pi as the automation controller while preserving the jukebox's original functionality. 

* Audio from the Raspberry Pi is converted to line-level using a USB-to-RCA DAC, allowing streaming services to play through the jukebox's existing speakers. 
* A passive mixer combines both the Raspberry Pi's audio output and the turntable's line-level signal, ensuring either source can play through the vintage speakers without switching or manual intervention.
* To enable automated song selection, relays are installed in parallel with each mechanical control button, giving the Raspberry Pi the ability to trigger selections electronically while leaving the original buttons fully operational. 

Several critical considerations shape the implementation.

* Power management is essential—a UPS (uninterruptible power supply) protects the Raspberry Pi from corruption during sudden power cuts, gracefully shutting down the system when mains power is lost. 
* WiFi connectivity allows the Pi to access streaming services and receive commands, though initial configuration requires careful setup to ensure reliable operation.
* Most importantly, users need intuitive control: a web-based interface accessible from any smartphone or tablet provides playlist management, streaming service integration, and autoplay configuration without requiring physical access to the jukebox.

This approach maintains the jukebox's authentic appearance—visitors see only the original cabinet and controls—while modern automation works invisibly behind the scenes.

## Components

The following is a list of the components required to complete this project

### Hardware

The list below is what I used - 

* An electro-mechanical Jukebox 
* A Raspberry Pi
* Raspberry Pi Power Supply 
* [LiNKFOR Passive Stereo Mixer](https://www.amazon.co.uk/LiNKFOR-Passive-Stereo-Mixer-Gold-Plated/dp/B0FHQ8PKBY)
* [Behringer UCA202 USB Audio Interface](https://www.behringer.com/product.html?modelCode=0805-AAC)
* [Waveshare RS485 CAN HAT](https://www.waveshare.com/rs485-can-hat.htm) ([Wiki](https://www.waveshare.com/rs485-can-hat.htm))
* [Waveshare Modbus RTU 16-Ch Relay Module, RS485 Interface](https://www.waveshare.com/modbus-rtu-relay-16ch.htm) ([Wiki](https://www.waveshare.com/wiki/Modbus_RTU_Relay_16CH))
* [Waveshare Relay Power Supply](https://www.waveshare.com/product/accessories/power-heat-sinks/power-supply/psu-5v5a-5.5-2.1.htm)
* [Geekworm Raspberry Pi X728 18650 UPS & Power](https://geekworm.com/products/x728?srsltid=AfmBOoqLg72DIKz7osYLtyZktOIUp77Lq9Mo0vHScv_tRI77IWSSSYi8) ([Wiki](https://wiki.geekworm.com/X728?_gl=1*ghwcdt*_gcl_au*MTI0OTIyNzg4OC4xNzYxMjA4NDM0*_ga*MTU3ODYxNDgzNi4xNzYxMjA4NDMz*_ga_WCBGYZY3V4*czE3NjEyMDg0MzMkbzEkZzAkdDE3NjEyMDg0MzMkajYwJGwwJGgw))


