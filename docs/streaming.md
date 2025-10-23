# Streaming Spotify/Apple Music 

There are multiple ways to stream music services to the Jukebox speakers that are connected to the Raspberry Pi.
Which one to use depends on what services you want/need for streaming

## Spotify Solutions

### Raspotify 

Website: https://github.com/dtcooper/raspotify

Turns your Pi into a Spotify Connect device that appears in your Spotify app just like a smart speaker.

**Installation:**
```bash
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh
```

**Features:**
- Requires Spotify Premium account
- Control from your phone/computer Spotify app
- Very stable and lightweight
- Seamless integration

## Apple Music Solutions

### Shairport Sync

Website: https://github.com/mikebrady/shairport-sync

Turns your Pi into an AirPlay receiver for streaming from iOS/Mac devices.

**Installation:**
```bash
sudo apt-get install shairport-sync
```

**Features:**
- Works with Apple Music and any other audio from iOS/Mac devices
- Good audio quality
- Easy to set up

## All-in-One Solutions

### Volumio

Website: https://volumio.com

Comprehensive music player with web interface supporting multiple services.

**Features:**
- Nice web interface
- Spotify Connect plugin (Premium required)
- AirPlay support for Apple Music
- Local files and web radio support
- Free with premium features available

**Installation:**
Download from [volumio.org](https://volumio.org)

## Recommendations

| Use Case | Best Solution |
|----------|---------------|
| Primarily Spotify | Raspotify |
| Primarily Apple Music | Shairport Sync |
| Both services | Volumio or Raspotify + Shairport Sync |
| Maximum flexibility | Volumio |

## Hardware Notes

- All solutions work with Raspberry Pi's built-in audio or USB DAC
- USB DAC recommended for better sound quality
- Compatible with all Raspberry Pi models with audio output

## Coexistence

Raspotify and Shairport Sync can run simultaneously on the same Pi, allowing you to use both Spotify Connect and AirPlay on one device.