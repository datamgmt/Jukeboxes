# New Equipment Dry-Run

## Purpose of This Dry-Run

This document guides you through assembling, configuring, and testing the complete jukebox control system **outside the jukebox enclosure**. By completing this dry-run successfully, you'll verify all components work together before final installation.

**Benefits:**
- Identify issues early in a controlled environment
- Learn the system thoroughly
- Test all functionality safely
- Build confidence before final installation
- Create a working backup configuration

---

## Components Checklist

### Hardware
```
□ Raspberry Pi 5 (or other as available)
□ Raspberry Pi Official Power Supply (5V 5A for Pi 5)
□ MicroSD card (32GB+ recommended, with OS pre-flashed)
□ LINKFOR Passive Stereo Mixer (2-channel)
□ Behringer UCA202 USB Audio Interface
□ Waveshare RS485 CAN HAT
□ Waveshare Modbus RTU 16-Ch Relay Module (RS485 Interface)
□ Waveshare Relay Power Supply (12V DC recommended)
□ SupTronics X1200 5.1V 5A UPS for Raspberry Pi 5
□ Two 18650 Lithium-ion Rechargeable Cells (for UPS)
□ External Speaker with Line In (for testing)
```

### Cables and Connectors
```
□ RCA cables (2-3 pairs, male-to-male)
□ 3.5mm to RCA cable (if speaker requires it)
□ Ethernet cable (for initial setup, optional)
□ RS485 cable or jumper wires (for HAT to Relay connection)
□ USB-A to USB-B cable (for UCA202)
□ Power cables for relay module
```

### Tools
```
□ Multimeter (for testing relay contacts)
□ Small screwdriver set (for terminal blocks)
□ Wire strippers (if needed)
□ Label maker or masking tape and marker
□ Laptop/phone for photographs as required
□ Notepad for recording settings
```

### Software/Files
```
□ Raspberry Pi OS image (latest version)
□ Node-RED flow files (.json)
□ Configuration scripts
□ SSH client (PuTTY, Terminal, etc.)
```

---

## ⚠️ Safety Precautions

**CRITICAL SAFETY RULES:**
1. Never work on powered circuits
2. Double-check all connections before applying power
3. Keep liquids away from electronics
4. Use insulated tools when working with connections
5. Ensure proper ventilation for battery charging
6. Never short circuit battery terminals
7. Verify voltage levels before connecting components

**Battery Safety:**
- Only use quality 18650 cells with protection circuits
- Check cell polarity before installation
- Do not over-discharge or over-charge
- Monitor battery temperature during charging
- Have a fire extinguisher nearby during initial testing

---

## Phase 1: Workspace Preparation

### 1.1 Setup Workspace

**Requirements:**
- Clean, flat, non-conductive surface
- Good lighting
- Power outlets nearby
- Plenty of room to spread out components

**Steps:**
1. Clear workspace of clutter and metal objects
2. Lay down anti-static mat or clean cloth
3. Organize components by category
4. Have tools within easy reach
5. Set up laptop/monitor for Pi configuration

### 1.2 Initial Inspection

**Inspect each component:**
```
□ Raspberry Pi - no physical damage
□ UPS board - no damaged components or traces
□ RS485 HAT - pins straight, no damage
□ Relay module - terminals clean, LEDs intact
□ UCA202 - USB connector intact
□ All cables - no cuts or damaged connectors
□ Power supplies - correct voltage ratings
```

---

## Phase 2: Hardware Assembly

### 2.1 Install UPS on Raspberry Pi

**The SupTronics X1200 UPS:**
- Provides 5.1V 5A power to Pi 5
- Uses two 18650 batteries for backup
- Mounts directly on Pi GPIO header

**Installation Steps:**

1. **Prepare the UPS:**
   - Verify battery polarity markings on UPS board
   - DO NOT insert batteries yet
   
2. **Mount UPS to Raspberry Pi:**
   - Ensure Pi is powered OFF
   - Align UPS GPIO pins with Pi header (all 40 pins)
   - Gently press down until fully seated
   - UPS should sit flat on Pi with no gaps
   
3. **Install Batteries:**
   - Verify 18650 cell polarity (+ and -)
   - Insert first cell, positive end first
   - Insert second cell, positive end first
   - Check for proper contact
   - Verify voltage with multimeter (should read ~7-8.4V total)

4. **Connect UPS Power:**
   - Use Pi official power supply
   - Connect to UPS power input (NOT directly to Pi)
   - UPS will begin charging batteries
   - Check charging LED indicator

**⚠️ STOP:** Do not power on yet. Complete all connections first.

---

### 2.2 Install RS485 CAN HAT

**The Waveshare RS485 CAN HAT:**
- Provides RS485 communication interface
- Stacks on top of UPS if pins available, or use GPIO extender
- Communicates via UART

**Installation Options:**

**Option A: Stacking (if UPS allows pass-through):**
1. Align RS485 HAT pins with UPS header
2. Press down gently until seated
3. Secure with standoffs if provided

**Option B: GPIO Extender/Ribbon:**
1. Use 40-pin ribbon cable or extender
2. Connect to available GPIO pins
3. Mount HAT separately on workspace

**Wiring Notes:**
- RS485 HAT uses GPIO14 (TXD) and GPIO15 (RXD)
- Note which UART port is used (usually /dev/ttyS0 or /dev/ttyAMA0)

---

### 2.3 Connect RS485 HAT to Relay Module

**The Waveshare Modbus RTU 16-Ch Relay Module:**
- Controls up to 16 relays via Modbus protocol
- Powered separately (12V DC recommended)
- Communicates via RS485 (A, B terminals)

**RS485 Connection:**

1. **Identify Terminals:**
   - On RS485 HAT: A+, B-
   - On Relay Module: A(+), B(-)

2. **Wire Connection:**
   ```
   RS485 HAT          Relay Module
   A+     ----------> A(+)
   B-     ----------> B(-)
   ```

3. **Secure Connections:**
   - Use small screwdriver to loosen terminal screws
   - Insert wire fully into terminal
   - Tighten screw firmly
   - Tug gently to verify secure connection
   - Label wires with tape

4. **Check Relay Module Address:**
   - Default Modbus address usually 0x01 (address 1)
   - Note this for software configuration

**Cable Specifications:**
- Use twisted pair wire for A/B lines
- Maximum cable length: 1200m 
- Minimise cablem length: <1m should be sufficient
- Keep away from power cables to reduce interference

---

### 2.4 Power the Relay Module

**Relay Module Power Supply:**

1. **Verify Voltage:**
   - Check relay module requirements (typically 12V DC)
   - Verify Waveshare power supply matches
   - Use multimeter to confirm output voltage

2. **Connect Power:**
   ```
   Power Supply       Relay Module
   +12V   ----------> VCC/V+ terminal
   GND    ----------> GND terminal
   ```

3. **Double-Check Polarity:**
   - Red wire = Positive (+)
   - Black wire = Negative (-)
   - Incorrect polarity can damage module

4. **Cable Management:**
   - Secure power cables away from signal wires
   - Prevent accidental disconnection
   - Label power connections

**⚠️ STOP:** Do not plug in power supply yet.

---

### 2.5 Connect Audio Components

#### 2.5.1 Connect Behringer UCA202 to Raspberry Pi

**UCA202 Setup:**
1. Connect USB-B end to UCA202
2. Connect USB-A end to Raspberry Pi USB port
3. Use USB 2.0 or 3.0 port (any will work)
4. Keep cable tidy and secured

#### 2.5.2 Connect UCA202 to LINKFOR Mixer

**Audio Path:** Pi → UCA202 → Mixer → Speaker

**Connections:**
1. **UCA202 Output to Mixer Input:**
   ```
   UCA202 RCA Outputs  →  Mixer INPUT 2 
   Red (Right)         →  Red/Right Input
   White (Left)        →  White/Left Input
   ```

2. **Set Mixer Controls:**
   - INPUT 2 volume: 50% (middle position)
   - Master volume: 50% (middle position)
   - Other inputs: Minimum or off

#### 2.5.3 Connect Speaker

**Mixer to Speaker:**

**Option A: If speaker has RCA inputs:**
```
Mixer OUTPUT        →  Speaker RCA Input
Red (Right)         →  Red/Right
White (Left)        →  White/Left
```

**Option B: If speaker has 3.5mm input:**
```
Mixer OUTPUT → RCA to 3.5mm adapter → Speaker 3.5mm input
```

**Speaker Power:**
- Connect speaker to AC power outlet
- Keep speaker volume at 30% initially
- Position speaker away from microphones or sensitive equipment

---

### 2.6 Connection Summary Diagram

```
┌─────────────────────────────────────┐
│  RASPBERRY PI 5                     │
│  ┌─────────────────────────────┐    │
│  │ SupTronics X1200 UPS        │    │
│  │ [●●] 18650 Batteries        │    │
│  │ └─ Charging LED             │    │
│  └─────────────────────────────┘    │
│         ▲                           │
│         │ Power In (5V 5A)          │
│         │                           │
│  ┌─────────────────────────────┐    │
│  │ Waveshare RS485 CAN HAT     │    │
│  │  A+  B-                     │    │
│  └──┬───┬──────────────────────┘    │
│     │   │                           │
│     │   │      USB ─────────────┐   │
│     │   │                       │   │
└─────┼───┼───────────────────────┼───┘
      │   │                       │
      │   │                       │
      │   │      ┌────────────────▼──────────┐
      │RS485     │ Behringer UCA202          │
      │Twisted   │ USB Audio Interface       │
      │Pair      │  RCA Out: L ● ●R          │
      │Cable     └─────────┬──────┬──────────┘
      │   │                │      │
      │   │                │RCA   │RCA
      │   │                │Cable │Cable
      │   │                │      │
      ▼   ▼                ▼      ▼
┌─────────────────────┐  ┌──────────────────┐
│ Waveshare Modbus    │  │ LINKFOR Mixer    │
│ RTU 16-Ch Relay     │  │                  │
│                     │  │ IN 1: ─  ─       │
│  A(+) B(-) GND      │  │ IN 2: L● ●R      │
│                     │  │                  │
│  VCC(12V)  GND      │  │                  │
│    ▲        │       │  │                  │
│    │        │       │  │ OUT:  L● ●R      │
│    │   ┌────┘       │  └──┬────┬──────────┘
│    │   │            │     │    │
│ Relay Outputs:      │     │RCA │RCA
│  NO1 COM1 NC1       │     │    │
│  NO2 COM2 NC2       │     ▼    ▼
│  ...                │  ┌──────────────────┐
│  Status LEDs        │  │ Test Speaker     │
└──┬──────────────────┘  │ with Line Input  │
   │                     │                  │
   │ 12V Power Supply    │ [Volume: 30%]    │
   │ ────────────        └──────────────────┘
   
Legend:
● = Connected
─ = Not connected
▲/▼ = Direction of connection
```

---

### 2.7 Pre-Power Checklist

**Before applying power, verify:**

```
□ All GPIO connections properly seated
□ No bent pins on any headers
□ RS485 wiring correct (A to A, B to B)
□ Relay module polarity correct (+ to +, - to -)
□ No loose wires or exposed conductors
□ No metal objects on workspace
□ UCA202 USB connected to Pi
□ Audio cables connected: UCA202 → Mixer → Speaker
□ Speaker plugged in and volume low
□ Batteries installed correctly in UPS
□ UPS power supply ready (not connected yet)
□ Relay power supply ready (not connected yet)
□ Monitor, keyboard, mouse connected to Pi
□ Multimeter ready for testing
□ Fire extinguisher nearby (for battery safety)
□ Camera ready to document setup
```

**Take Photos:**
- Top view of entire setup
- Close-ups of all connections
- RS485 wiring
- Power connections
- Label with date/time

---

## Phase 3: Initial Power-Up

### 3.1 Power-Up Sequence

**IMPORTANT:** Power up in this specific order to prevent damage.

**Step 1: Relay Module**
1. Plug in relay module power supply to outlet
2. Observe:
   - Power LED should illuminate
   - No smoke or strange smells
   - Relays should NOT activate (all off)
3. If any issues, unplug immediately

**Step 2: Raspberry Pi (via UPS)**
1. Plug in UPS power supply to outlet
2. Observe:
   - UPS charging LED should light
   - Pi should begin boot sequence
   - Monitor should display boot messages
   - Wait for boot to complete (~30-60 seconds)
3. If any issues, unplug immediately

**Step 3: Speaker**
1. Turn on speaker (if not already powered)
2. Verify power LED on speaker
3. Keep volume at 30%

**Success Indicators:**
- Pi boots to desktop or login prompt
- UPS charging LED on
- Relay module power LED on
- No error messages on screen
- No burning smells or excessive heat

---

### 3.2 Initial System Check

**Raspberry Pi Check:**
```
□ Pi boots successfully
□ login prompt appears via ssh
□ No error messages displayed
□ Green activity LED flashing (disk activity)
□ Red power LED solid
```

**UPS Check:**
```
□ Charging LED on (red or orange typically)
□ No error LEDs
□ Batteries not hot
□ Voltage reading normal (check with multimeter if accessible)
```

**Relay Module Check:**
```
□ Power LED on
□ All relay LEDs off (no relays activated)
□ No unusual sounds (clicking without commands)
□ Module not excessively hot
```

**Audio Hardware Check:**
```
□ UCA202 LED indicator on (if present)
□ No ground loop hum from speaker
□ Speaker powered on
```

**If all checks pass:** Proceed to software configuration.  
**If any check fails:** Power down, investigate, and resolve before continuing.

---

## Phase 4: Software Configuration

### 4.1 Operating System Setup

#### 4.1.1 First Boot Configuration

**If using Raspberry Pi OS with Desktop:**

1. **Complete Initial Setup Wizard:**
   ```
   □ Set country, language, timezone
   □ Set password (RECORD THIS SECURELY)
   □ Configure screen (if prompted)
   □ Skip WiFi for now (configure next)
   □ Update software when prompted
   ```

2. **Update System:**
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```
   This may take 10-30 minutes. Be patient.

3. **Enable SSH:**
   ```bash
   sudo raspi-config
   # Navigate to: Interface Options → SSH → Enable
   ```

4. **Reboot:**
   ```bash
   sudo reboot
   ```

---

### 4.2 WiFi Configuration

#### 4.2.1 Connect to WiFi

**Method 1: Desktop GUI**
1. Click WiFi icon in taskbar (top-right)
2. Select your network
3. Enter password
4. Verify connection (WiFi icon should show signal strength)

**Method 2: Command Line**
```bash
sudo raspi-config
# Navigate to: System Options → Wireless LAN
# Enter SSID (network name)
# Enter password
```

**Method 3: Edit wpa_supplicant**
```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

Add:
```
network={
    ssid="YOUR_NETWORK_NAME"
    psk="YOUR_PASSWORD"
}
```

Save (Ctrl+X, Y, Enter) and reboot.

#### 4.2.2 Set Static IP (Recommended)

**Find your current IP:**
```bash
hostname -I
```

**Edit dhcpcd.conf:**
```bash
sudo nano /etc/dhcpcd.conf
```

**Add at bottom (adjust for your network):**
```
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

**Save and reboot:**
```bash
sudo reboot
```

**Verify new IP:**
```bash
hostname -I
# Should show your static IP
```

**Record your Pi's IP address:** _________________

---

### 4.3 Security Configuration

#### 4.3.1 Change Default Password (if not already done)

```bash
passwd
# Enter current password
# Enter new password (strong password!)
# Confirm new password
```

**Password Requirements:**
- At least 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Not dictionary words
- RECORD SECURELY

#### 4.3.2 Update System Packages

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
```

#### 4.3.3 Configure Firewall (UFW)

**Install UFW:**
```bash
sudo apt install ufw -y
```

**Configure basic rules:**
```bash
# Allow SSH
sudo ufw allow 22/tcp

# Allow Node-RED (if accessing externally)
sudo ufw allow 1880/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

#### 4.3.4 Disable Root Login

```bash
sudo nano /etc/ssh/sshd_config
```

Find and change:
```
PermitRootLogin no
```

Save and restart SSH:
```bash
sudo systemctl restart ssh
```

#### 4.3.5 Setup Automatic Security Updates

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
# Select "Yes"
```

#### 4.3.6 Create Backup User (Optional but Recommended)

```bash
sudo adduser backup
sudo usermod -aG sudo backup
```

Test by logging in as backup user via SSH before proceeding.

---

### 4.4 Configure RS485/Modbus Communication

#### 4.4.1 Enable Serial Port

```bash
sudo raspi-config
# Navigate to: Interface Options → Serial Port
# "Would you like a login shell accessible over serial?" → NO
# "Would you like the serial port hardware enabled?" → YES
```

Reboot:
```bash
sudo reboot
```

#### 4.4.2 Install Python Modbus Library

```bash
sudo apt install python3-pip -y
pip3 install pymodbus --break-system-packages
```

#### 4.4.3 Test Serial Port

**Check available serial ports:**
```bash
ls -l /dev/tty*
```

Look for `/dev/ttyS0` or `/dev/ttyAMA0`

**Test communication:**
```bash
sudo apt install minicom -y
sudo minicom -b 9600 -D /dev/ttyS0
# Press Ctrl+A then X to exit
```

#### 4.4.4 Verify Relay Module Communication

**Create test script:**
```bash
nano test_modbus.py
```

**Add this code:**
```python
#!/usr/bin/env python3
from pymodbus.client import ModbusSerialClient

# Configure serial connection
client = ModbusSerialClient(
    port='/dev/ttyS0',  # Adjust if using different port
    baudrate=9600,
    bytesize=8,
    parity='N',
    stopbits=1,
    timeout=1
)

# Connect to relay module
if client.connect():
    print("✓ Connected to Modbus relay module")
    
    # Read relay states (address 1, starting at register 0, read 16 registers)
    result = client.read_holding_registers(address=0, count=16, slave=1)
    
    if not result.isError():
        print(f"✓ Successfully read relay states: {result.registers}")
    else:
        print("✗ Error reading relays")
    
    client.close()
else:
    print("✗ Failed to connect to relay module")
    print("Check wiring and relay module address")
```

**Run test:**
```bash
python3 test_modbus.py
```

**Expected output:**
```
✓ Connected to Modbus relay module
✓ Successfully read relay states: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
```

**If connection fails:**
- Check RS485 wiring (A to A, B to B)
- Verify relay module power
- Check relay module address (default usually 1)
- Try different baud rate (9600, 19200, 115200)
- Check DIP switches on relay module

---

### 4.5 Configure Audio (UCA202)

#### 4.5.1 Verify UCA202 Detection

```bash
aplay -l
```

**Expected output (similar to):**
```
card 0: Headphones [bcm2835 Headphones], device 0: bcm2835 Headphones [bcm2835 Headphones]
card 1: CODEC [USB Audio CODEC], device 0: USB Audio [USB Audio]
```

Note the card number for UCA202 (usually `card 1`)

#### 4.5.2 Set UCA202 as Default Audio Output

**Edit ALSA config:**
```bash
sudo nano /etc/asound.conf
```

**Add (adjust card number if different):**
```
defaults.pcm.card 1
defaults.ctl.card 1
```

Save and reboot:
```bash
sudo reboot
```

#### 4.5.3 Test Audio Output

**Play test sound:**
```bash
speaker-test -c2 -t wav -D hw:1,0
```

**You should hear:**
- "Front Left" from left speaker
- "Front Right" from right speaker
- Alternating between channels

Press Ctrl+C to stop.

#### 4.5.4 Adjust Volume Levels

```bash
alsamixer
```

**In alsamixer:**
- Press F6 to select sound card
- Choose USB Audio CODEC
- Use arrow keys to adjust volume
- Set to 90-100% (UCA202 has hardware volume control)
- Press Esc to exit

**Test volume:**
```bash
speaker-test -c2 -t wav
```

---

### 4.6 Install and Configure Node-RED

#### 4.6.1 Install Node-RED

**Install using official script:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
```

**Answer prompts:**
- Install Pi-specific nodes? → Yes
- Takes 15-30 minutes

#### 4.6.2 Enable Node-RED Service

```bash
sudo systemctl enable nodered.service
sudo systemctl start nodered.service
```

**Check status:**
```bash
sudo systemctl status nodered.service
```

Should show "active (running)"

#### 4.6.3 Access Node-RED

**Open browser and navigate to:**
```
http://192.168.1.100:1880
```
(Use your Pi's IP address)

**You should see:**
- Node-RED editor interface
- Flow tabs at top
- Node palette on left
- Deploy button (top-right)

#### 4.6.4 Install Required Node-RED Nodes

**Open Node-RED palette manager:**
1. Click menu (☰) → Manage palette
2. Go to "Install" tab

**Install these nodes:**
```
□ node-red-contrib-modbus (for relay control)
□ node-red-dashboard (optional, for UI)
□ node-red-node-pi-gpio (for direct GPIO if needed)
```

Search for each, click Install, confirm.

**Wait for installation to complete** (green checkmarks appear)

**Restart Node-RED:**
```bash
sudo systemctl restart nodered.service
```

---

### 4.7 Import Node-RED Flows

#### 4.7.1 Prepare Flow Files

**You should have `.json` flow files ready. If not, they are in this repository:**

[flows.json](/code/node-red)

#### 4.7.2 Import Your Custom Flows

**If you have custom flow files:**

1. Click menu (☰) → Import
2. Click "select a file to import"
3. Choose your `.json` file
4. Click "Import"
5. Position the flow on canvas

#### 4.7.3 Configure Modbus Client Node

1. Double-click any Modbus node
2. Edit the "Server" configuration
3. Verify settings:
   ```
   Serial Port: /dev/ttyS0 (or your serial port)
   Baud Rate: 9600
   Data Bits: 8
   Stop Bits: 1
   Parity: None
   Unit ID: 1 (your relay module address)
   ```
4. Click "Update"
5. Click "Done"

#### 4.7.4 Deploy Flows

1. Click red "Deploy" button (top-right)
2. Wait for "Successfully deployed" message
3. Check for errors in debug panel (right side)

**Troubleshooting:**
- Red triangles on nodes = configuration issue
- Check debug output for error messages
- Verify serial port path
- Confirm Modbus address matches relay module

---

### 4.8 Configure UPS Monitoring

#### 4.8.1 Install UPS Monitoring Software

**SupTronics X1200 uses I2C communication:**

**Enable I2C:**
```bash
sudo raspi-config
# Interface Options → I2C → Enable
```

Reboot:
```bash
sudo reboot
```

**Install I2C tools:**
```bash
sudo apt install i2c-tools python3-smbus -y
```

**Detect UPS:**
```bash
sudo i2cdetect -y 1
```

Should show device at address (typically 0x36 for battery monitoring)

#### 4.8.2 Install X1200 Software

**Check SupTronics website or documentation for official scripts.**

**Basic battery monitoring script example:**
```bash
nano ups_monitor.py
```

```python
#!/usr/bin/env python3
import smbus
import time

bus = smbus.SMBus(1)
address = 0x36  # Adjust based on your UPS

def read_voltage():
    # Read battery voltage (implementation depends on UPS chip)
    # This is a placeholder - use official X1200 library
    try:
        data = bus.read_word_data(address, 0x02)
        voltage = data * 0.00125  # Example conversion
        return voltage
    except:
        return None

while True:
    voltage = read_voltage()
    if voltage:
        print(f"Battery: {voltage:.2f}V")
    time.sleep(10)
```

**Make executable:**
```bash
chmod +x ups_monitor.py
```

**Run:**
```bash
python3 ups_monitor.py
```

---

### 4.9 Modify Configuration Scripts

#### 4.9.1 Locate Configuration Files

**Common locations:**
```bash
# Node-RED user directory
cd ~/.node-red

# System configuration
cd /etc

# User scripts
cd ~/scripts  # or wherever your scripts are
```

#### 4.9.2 Edit Configuration Scripts

**Example: Edit Modbus settings**
```bash
nano ~/.node-red/settings.js
```

**Example: Edit startup script**
```bash
nano ~/scripts/startup.sh
```

**Make changes as needed:**
- Update IP addresses
- Adjust timing values
- Modify relay mappings
- Update audio settings

#### 4.9.3 Set Scripts to Run at Boot

**Edit rc.local:**
```bash
sudo nano /etc/rc.local
```

**Add before `exit 0`:**
```bash
# Start jukebox scripts
/home/pi/scripts/startup.sh &
```

**Or create systemd service:**
```bash
sudo nano /etc/systemd/system/jukebox.service
```

```ini
[Unit]
Description=Jukebox Control Service
After=network.target

[Service]
Type=simple
User=pi
ExecStart=/home/pi/scripts/startup.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

**Enable service:**
```bash
sudo systemctl enable jukebox.service
sudo systemctl start jukebox.service
```

---

## Phase 5: Testing Procedures

### 5.1 Test WiFi Connectivity

#### 5.1.1 Basic Connectivity Test

**From Pi terminal:**
```bash
# Test internet connectivity
ping -c 4 google.com

# Test local network
ping -c 4 192.168.1.1  # Your router IP

# Check WiFi signal strength
iwconfig wlan0
```

**Expected results:**
```
□ 0% packet loss to internet
□ 0% packet loss to router
□ Signal level above -70 dBm (stronger is better)
□ Link Quality above 50/70
```

#### 5.1.2 SSH Connectivity Test

**From laptop/another computer:**
```bash
ssh pi@192.168.1.100  # Use your Pi's IP
```

**Should connect without timeout.**

#### 5.1.3 Speed Test (Optional)

```bash
# Install speedtest
sudo apt install speedtest-cli -y

# Run test
speedtest-cli
```

**Minimum requirements for music streaming:**
- Download: > 5 Mbps
- Upload: > 1 Mbps
- Ping: < 50ms

#### 5.1.4 Long-Term Stability Test

**Monitor connection over time:**
```bash
# Ping router continuously
ping 192.168.1.1 > ping_log.txt
```

Let run for 30+ minutes, then check:
```bash
# Count packets
cat ping_log.txt | grep "icmp_seq" | wc -l

# Check for errors
cat ping_log.txt | grep -i "error\|timeout"
```

**Success criteria:**
- No timeouts
- Consistent ping times
- No disconnections

---

### 5.2 Test Audio Streaming

#### 5.2.1 Install Music Streaming Software

**Install Raspotify (Spotify Connect):**
```bash
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh
```

**Configure Raspotify:**
```bash
sudo nano /etc/raspotify/conf
```

**Set:**
```bash
DEVICE_NAME="Jukebox-Test"
BITRATE="320"
DEVICE_TYPE="speaker"
```

**Restart service:**
```bash
sudo systemctl restart raspotify
```

#### 5.2.2 Stream Music Test

**Using Spotify:**
1. Open Spotify on phone/computer
2. Start playing music
3. Click "Devices Available" icon
4. Select "Jukebox-Test"
5. Music should play through speaker

**Verify:**
```
□ Music plays clearly without distortion
□ Both left and right channels working
□ Volume control works from Spotify app
□ No audio dropouts or stuttering
□ No clicking or popping sounds
□ Latency acceptable (< 1 second)
```

#### 5.2.3 Audio Quality Test

**Play test tones:**
```bash
# Low frequency test (bass)
speaker-test -c2 -t sine -f 100

# Mid frequency
speaker-test -c2 -t sine -f 1000

# High frequency (treble)
speaker-test -c2 -t sine -f 5000
```

Press Ctrl+C to stop each test.

**Listen for:**
- Clean tone without distortion
- Equal volume from both channels
- No buzzing or humming
- Full frequency range reproduction

#### 5.2.4 Volume Level Test

**Test volume range:**
1. Set mixer INPUT 2 to minimum
2. Play music
3. Gradually increase volume
4. Note usable range

**Optimal settings:**
- Mixer input: 50-70%
- Mixer output: 70-80%
- Speaker volume: 30-50%
- Spotify app: 80-100%

#### 5.2.5 Extended Playback Test

**Run for 2+ hours:**
1. Start music playlist
2. Monitor system temperature:
   ```bash
   watch -n 60 vcgencmd measure_temp
   ```
3. Check for:
   - No audio dropouts
   - No overheating (keep under 80°C)
   - Consistent quality
   - No WiFi disconnections

---

### 5.3 Test UPS Functionality

#### 5.3.1 Pre-Test Preparation

**Before testing UPS:**
```
□ Save all work and close applications
□ Ensure batteries fully charged (charge for 2+ hours)
□ Have terminal open to monitor system
□ Note current battery voltage
□ Have power supply plug easily accessible
□ Camera ready to record behavior
```

#### 5.3.2 UPS Basic Test

**Monitor script during test:**
```bash
# In one terminal, monitor system
watch -n 1 'uptime; vcgencmd measure_temp; vcgencmd get_throttled'

# In another terminal, monitor battery
python3 ups_monitor.py
```

**Perform test:**
1. Note current time
2. Pull power plug from UPS/Pi
3. Observe:
   ```
   □ Pi continues running (no reboot)
   □ No LED flickering
   □ No screen artifacts
   □ Music continues playing (if streaming)
   □ Battery monitoring shows discharge
   ```
4. Wait 30 seconds
5. Plug power back in
6. Observe:
   ```
   □ Charging indicator activates
   □ No interruption to operation
   □ Battery monitoring shows charging
   ```

**Record results:**
```
Test 1 - Power Loss:
Time unplugged: _____ seconds
Pi remained on: YES / NO
Battery voltage at start: _____ V
Battery voltage at end: _____ V
Any issues: _____________________
```

#### 5.3.3 Extended Power Loss Test

**Test battery runtime:**

1. Fully charge batteries (2+ hours)
2. Disconnect power
3. Monitor until shutdown or voltage threshold
4. Time the duration

**Record:**
```
Full charge voltage: _____ V
Runtime: _____ minutes
Shutdown voltage: _____ V
Graceful shutdown: YES / NO
```

**Expected runtime:**
- With 2x 3000mAh cells: 30-60 minutes (depending on load)
- Pi 5 alone: longer
- Pi 5 + relays + accessories: shorter

#### 5.3.4 Shutdown/Recharge Test

**Test safe shutdown:**
```bash
# Create low-battery shutdown script
nano ~/scripts/low_battery_shutdown.sh
```

```bash
#!/bin/bash
VOLTAGE=$(python3 -c "import smbus; bus=smbus.SMBus(1); print(bus.read_word_data(0x36, 0x02) * 0.00125)")
THRESHOLD=3.2

if (( $(echo "$VOLTAGE < $THRESHOLD" | bc -l) )); then
    echo "Low battery! Shutting down..."
    sudo shutdown -h now
fi
```

**Test:**
1. Disconnect power
2. Wait for battery to drain to threshold
3. Verify system shuts down gracefully
4. Reconnect power
5. Verify system boots normally

---

### 5.4 Test Relay Control

#### 5.4.1 Prepare for Relay Testing

**Safety first:**
```
□ Relays NOT connected to high voltage
□ Using low voltage test circuit or multimeter only
□ Fire extinguisher nearby
□ Well-ventilated area
```

**Set up multimeter:**
1. Set to continuity mode (beep symbol)
2. Or set to resistance mode (Ω)

#### 5.4.2 Test Individual Relays

**For EACH relay you plan to use (e.g., Relays 1-4):**

**Relay 1 Test:**

1. **Identify terminals on relay module:**
   ```
   Relay 1: NO1 (Normally Open)
           COM1 (Common)
           NC1 (Normally Closed)
   ```

2. **Test default state (relay OFF):**
   - Place multimeter probes on COM1 and NC1
   - Should show continuity (beep or ~0Ω)
   - Move probes to COM1 and NO1
   - Should show NO continuity (no beep, infinite resistance)

3. **Trigger relay ON via Node-RED:**
   - Open Node-RED interface
   - Click "Relay 1 ON" inject button
   - Observe relay module LED for Relay 1 (should light up)
   - Listen for relay "click"

4. **Test activated state (relay ON):**
   - Multimeter on COM1 and NO1
   - Should NOW show continuity (beep or ~0Ω)
   - Move probes to COM1 and NC1
   - Should show NO continuity (no beep, infinite resistance)

5. **Trigger relay OFF:**
   - Click "Relay 1 OFF" inject button
   - Relay LED should turn off
   - Relay should "click" again
   - Verify returned to default state

**Record results:**
```
Relay 1 Test:
OFF state - COM to NC: CONTINUITY / NO CONTINUITY
OFF state - COM to NO: CONTINUITY / NO CONTINUITY
ON state - COM to NC: CONTINUITY / NO CONTINUITY
ON state - COM to NO: CONTINUITY / NO CONTINUITY
LED indicator working: YES / NO
Audible click: YES / NO
Switches reliably: YES / NO
```

**Repeat for Relays 2, 3, 4, etc.**

#### 5.4.3 Rapid Switching Test

**Test relay durability:**

**Create rapid test flow in Node-RED:**
```json
[
    {
        "id": "rapid-test",
        "type": "inject",
        "name": "Rapid Test",
        "props": [{"p": "payload"}],
        "repeat": "1",  // Every 1 second
        "crontab": "",
        "once": false,
        "topic": "",
        "payload": "toggle",
        "x": 150,
        "y": 200,
        "wires": [["toggle-relay"]]
    },
    {
        "id": "toggle-relay",
        "type": "function",
        "name": "Toggle",
        "func": "context.state = !context.state;\nmsg.payload = context.state;\nreturn msg;",
        "x": 300,
        "y": 200,
        "wires": [["modbus-write-relay1"]]
    }
]
```

**Run test:**
1. Deploy flow
2. Let run for 100 cycles (100 seconds)
3. Monitor with multimeter
4. Verify consistent switching

**Stop test and verify:**
```
□ Relay still functions correctly
□ No stuck relay
□ LED still indicates state
□ Contacts still show proper continuity
```

#### 5.4.4 Multiple Relay Test

**Test controlling multiple relays simultaneously:**

1. **Create test that activates all relays:**
   - Add inject buttons for Relays 1-4
   - Click all "ON" buttons
   - Verify all 4 relays activate
   - Check LEDs on module
   - Test continuity on each relay

2. **Test independent control:**
   - Turn ON Relay 1, others OFF
   - Turn ON Relay 2, others OFF
   - Turn ON Relay 3, others OFF
   - Turn ON Relay 4, others OFF
   - Verify no cross-talk between relays

3. **Test patterns:**
   - All ON → All OFF
   - Alternating pattern (1&3 ON, 2&4 OFF)
   - Sequential activation (1→2→3→4)
   - Random pattern

**Record results:**
```
Multiple Relay Control:
All relays activate: YES / NO
Independent control: YES / NO
No cross-talk: YES / NO
Pattern control works: YES / NO
```

#### 5.4.5 Load Test (Optional)

**⚠️ ONLY if you have safe, low-voltage load:**

1. Connect LED or small 12V lamp to relay contacts
2. Activate relay
3. Verify load turns on/off with relay
4. Check for:
   - Relay handles load without overheating
   - Clean switching (no flickering)
   - Contacts not arcing (with appropriate load)

**Do NOT test with:**
- AC mains voltage
- High inductive loads (motors without protection)
- Anything that could cause injury

---

### 5.5 Integration Test - Full System

#### 5.5.1 End-to-End Test Scenario

**Simulate jukebox operation:**

**Test Sequence:**
1. Play music via Spotify
2. Trigger Relay 1 (simulate motor power)
3. Wait 2 seconds
4. Trigger Relay 2 (simulate another function)
5. Music continues throughout
6. Turn off relays
7. Music continues

**Verify:**
```
□ Music streams without interruption
□ Relays activate on command
□ No audio clicks/pops when relays switch
□ No interference between systems
□ WiFi remains stable
□ System responsive
```

#### 5.5.2 Power Failure During Operation Test

**Simulate real-world power loss:**

1. Start music streaming
2. Activate 2 relays
3. Monitor system load
4. Pull power plug
5. Verify:
   ```
   □ UPS takes over seamlessly
   □ Music continues playing
   □ Relays remain in state
   □ No system instability
   ```
6. Reconnect power after 30 seconds
7. Verify:
   ```
   □ Transition to mains power smooth
   □ No interruptions
   □ Charging resumes
   ```

#### 5.5.3 Node-RED Automation Test

**If you have automation flows:**

**Test automation scenarios:**
```
□ Time-based triggers work
□ Input triggers work (if using buttons/sensors)
□ Relay sequences execute correctly
□ Audio control integrates with relay control
□ Error handling works (e.g., Modbus timeout)
```

#### 5.5.4 Recovery Test

**Test system recovery from failures:**

**Test 1: Software crash recovery**
```bash
# Crash Node-RED
sudo killall -9 node-red

# Verify it restarts
sudo systemctl status nodered

# Should auto-restart
```

**Test 2: Network recovery**
```bash
# Disable WiFi
sudo ifconfig wlan0 down

# Wait 30 seconds

# Re-enable
sudo ifconfig wlan0 up

# Verify reconnection
ping google.com
```

**Test 3: Modbus recovery**
- Disconnect RS485 cable
- Try to trigger relay (will fail)
- Reconnect cable
- Retry relay (should recover)

---

### 5.6 Performance Monitoring

#### 5.6.1 System Resource Check

**Monitor during operation:**
```bash
# CPU and memory
htop

# Temperature
watch -n 5 vcgencmd measure_temp

# Disk usage
df -h
```

**Acceptable ranges:**
```
CPU usage: < 50% idle, < 80% under load
Memory: < 70% used
Temperature: < 70°C idle, < 80°C load
Disk: > 20% free
```

#### 5.6.2 Log Review

**Check system logs for errors:**
```bash
# System log
sudo tail -n 100 /var/log/syslog

# Node-RED log
sudo journalctl -u nodered -n 100

# Modbus errors
cat ~/.node-red/logs/* | grep -i error
```

**Look for:**
- Modbus communication errors
- Audio dropouts
- Thermal throttling
- Network issues

---

## Phase 6: Documentation and Cleanup

### 6.1 Document Configuration

**Create configuration document:**
```bash
nano ~/jukebox_config.txt
```

**Record all settings:**
```
=== JUKEBOX CONFIGURATION ===

NETWORK:
Static IP: 192.168.1.100
Gateway: 192.168.1.1
WiFi SSID: YourNetworkName

AUDIO:
Output Device: card 1 (UCA202)
Mixer Settings:
  Input 1: 70%
  Master: 80%
Speaker Volume: 30%

MODBUS/RS485:
Serial Port: /dev/ttyS0
Baud Rate: 9600
Relay Address: 1

UPS:
Battery Cells: 2x 18650
Capacity: 3000mAh each
Runtime: ~45 minutes

RELAYS IN USE:
Relay 1: Motor power
Relay 2: Amplifier
Relay 3: Lighting
Relay 4: Reserved

NODE-RED:
URL: http://192.168.1.100:1880
Flows: [list flow names]

PASSWORDS:
Pi User: [stored securely separately]
WiFi: [stored securely separately]

NOTES:
- Test completed: [date]
- Issues found: [list]
- Resolved: [list]
```

### 6.2 Create Backup

**Backup configuration files:**
```bash
# Create backup directory
mkdir ~/jukebox-backup

# Backup Node-RED flows
cp ~/.node-red/flows*.json ~/jukebox-backup/

# Backup settings
cp ~/.node-red/settings.js ~/jukebox-backup/

# Backup custom scripts
cp -r ~/scripts ~/jukebox-backup/

# Backup network config
sudo cp /etc/dhcpcd.conf ~/jukebox-backup/

# Backup audio config
cp /etc/asound.conf ~/jukebox-backup/

# Create archive
tar -czf jukebox-backup.tar.gz ~/jukebox-backup/
```

**Copy to external storage or cloud**

### 6.3 Take Reference Photos

**Photograph:**
```
□ Complete setup (overview)
□ RS485 wiring connections
□ Relay module connections
□ Audio routing (mixer, cables)
□ UPS installation on Pi
□ Relay terminal connections (close-up)
□ Label all photos with descriptions
```

### 6.4 Create Troubleshooting Quick Reference

```bash
nano ~/troubleshooting.txt
```

```
=== QUICK TROUBLESHOOTING ===

NO AUDIO:
1. Check mixer volumes not muted
2. Verify UCA202 connected: aplay -l
3. Test: speaker-test -c2 -t wav
4. Check speaker power and volume

NO WIFI:
1. Check connection: iwconfig wlan0
2. Restart: sudo systemctl restart networking
3. Reboot if needed

RELAYS NOT WORKING:
1. Check power to relay module
2. Verify RS485 wiring: A-A, B-B
3. Test Modbus: python3 test_modbus.py
4. Check Node-RED debug output

UPS NOT CHARGING:
1. Verify power supply connected to UPS input
2. Check charging LED
3. Verify battery polarity
4. Monitor: python3 ups_monitor.py

NODE-RED NOT RESPONDING:
1. Check service: sudo systemctl status nodered
2. Restart: sudo systemctl restart nodered
3. Check logs: sudo journalctl -u nodered

SYSTEM SLOW/HOT:
1. Check temp: vcgencmd measure_temp
2. If >80°C, improve cooling
3. Check CPU: htop
4. Close unnecessary apps
```

---

## Final Dry-Run Checklist

### Hardware
```
□ Raspberry Pi boots and runs stably
□ UPS installed and charging
□ UPS provides backup power when unplugged
□ RS485 HAT communicates with relay module
□ All planned relays tested and working
□ Relay switching reliable and consistent
□ UCA202 recognized and working
□ Audio plays through mixer to speaker
□ Audio quality good, no distortion
□ All cables secured and labeled
□ No excessive heat from any component
□ All LEDs functioning as expected
```

### Software
```
□ Raspberry Pi OS updated
□ WiFi connected with static IP
□ SSH access working
□ Security measures implemented
□ Serial port enabled and working
□ Modbus communication verified
□ Audio output configured correctly
□ Node-RED installed and running
□ Required Node-RED nodes installed
□ Flows imported and deployed
□ Configuration scripts modified as needed
□ UPS monitoring working (if applicable)
□ All services start at boot
```

### Testing
```
□ WiFi stable over 1+ hour
□ Music streams without dropouts
□ Multiple streaming tests successful
□ UPS takeover seamless
□ Battery runtime meets expectations
□ All relays switch correctly with multimeter
□ Rapid relay switching stable
□ Multiple relay control works
□ Full system integration test passed
□ Power failure test passed
□ Recovery from failures successful
□ System runs cool (<70°C)
□ No errors in logs
```

### Documentation
```
□ Configuration documented
□ Settings recorded
□ Photos taken of setup
□ Backup created
□ Troubleshooting guide written
□ Lessons learned recorded
```

---

## Success Criteria

**The dry-run is successful if:**

1. ✅ All hardware components power on correctly
2. ✅ Raspberry Pi boots reliably every time
3. ✅ WiFi maintains stable connection
4. ✅ Music streams clearly without interruptions
5. ✅ UPS provides seamless backup power
6. ✅ All relays switch reliably on command
7. ✅ No shorts, sparks, smoke, or overheating
8. ✅ System recovers from simulated failures
9. ✅ All tests pass multiple times
10. ✅ You feel confident to proceed with installation

---

## Next Steps After Successful Dry-Run

1. **Power Down Properly:**
   ```bash
   sudo shutdown -h now
   ```
   Wait for green LED to stop flashing, then unplug

2. **Carefully Disassemble for Transport:**
   - Label all connections before disconnecting
   - Store components safely
   - Keep screws/hardware together
   - Protect RS485 HAT pins

3. **Prepare for Jukebox Installation:**
   - Review jukebox internal layout
   - Plan component mounting locations
   - Prepare mounting hardware
   - Plan cable routing

4. **Schedule Installation:**
   - Allow 3-4 hours for careful installation
   - Have all tools ready
   - Print this documentation
   - Have backup plan if issues arise

---

## Troubleshooting Common Issues

### Audio Issues

**No sound from speaker:**
- Verify UCA202 USB connected
- Check `aplay -l` shows USB Audio
- Verify mixer not muted
- Test with `speaker-test`
- Check speaker power and volume

**Distorted sound:**
- Lower mixer input volume
- Reduce software volume in Spotify/source
- Check speaker not overdriving
- Verify good WiFi signal (for streaming)

**Hum or buzz:**
- Check ground loop (all devices on same outlet)
- Keep audio cables away from power cables
- Verify all audio connections secure
- Try different USB port for UCA202

### Relay Issues

**Relays don't switch:**
- Verify relay module power connected
- Check RS485 wiring (A-A, B-B, GND-GND)
- Confirm serial port enabled: `ls /dev/ttyS0`
- Test Modbus: `python3 test_modbus.py`
- Check relay module address matches config

**Some relays work, others don't:**
- Test each individually
- May be faulty relay on module
- Check if relay is jumpered/configured differently
- Verify Node-RED flow targets correct relay addresses

**Relays activate randomly:**
- Check for electrical noise on RS485 line
- Verify proper termination (if using long cables)
- Check for loose connections
- May need to add pull-up/pull-down resistors

### UPS Issues

**UPS not charging:**
- Verify power supply voltage (5V 5A minimum)
- Check battery polarity
- Verify batteries good (test with multimeter)
- Check UPS charging circuit (consult manual)

**Pi shuts down immediately when unplugged:**
- Batteries not charged (charge 2+ hours)
- Batteries faulty or dead
- UPS circuit issue
- Check battery voltage with multimeter

**UPS overheating:**
- Improve ventilation
- Check for excessive current draw
- Verify correct batteries (3.7V lithium, protected)
- May need lower-current load

### Network Issues

**WiFi won't connect:**
- Verify SSID and password correct
- Check router 2.4GHz enabled (Pi 5 also has 5GHz)
- Try Ethernet cable first to configure
- Check country code: `sudo raspi-config`

**WiFi keeps dropping:**
- Check signal strength: `iwconfig wlan0`
- Move closer to router
- Reduce WiFi interference (other devices)
- Update Pi firmware: `sudo rpi-update`
- Try external USB WiFi adapter

### Node-RED Issues

**Node-RED won't start:**
- Check logs: `sudo journalctl -u nodered`
- Verify installation: `node-red --version`
- Check port 1880 not in use: `sudo lsof -i :1880`
- Try manual start: `node-red`

**Flows won't deploy:**
- Check for node configuration errors (red triangles)
- Verify required nodes installed
- Check debug panel for error messages
- Try restarting Node-RED

---

## Emergency Procedures

### If Smoke or Burning Smell

1. **IMMEDIATELY unplug everything**
2. Do not reconnect power
3. Inspect all components for damage
4. Check for shorts (multimeter continuity test)
5. Replace damaged components
6. Investigate root cause before repowering

### If Component Gets Very Hot

1. Unplug power immediately
2. Allow to cool
3. Check for shorts or incorrect voltage
4. Verify current draw within limits
5. Improve ventilation
6. May need heat sinks or active cooling

### If Batteries Swell or Get Hot

1. Unplug power immediately
2. Disconnect batteries carefully
3. Place in fireproof container outdoors
4. Do not puncture or reuse swollen batteries
5. Dispose of properly at battery recycling center
6. Replace with quality protected 18650 cells

### If System Becomes Unresponsive

1. Try SSH connection first
2. If no response, hold power button 10 seconds
3. Or disconnect power as last resort
4. Wait 30 seconds before repowering
5. Check logs after reboot
6. Investigate cause before continuing

---

## Appendix: Command Reference

### System Commands
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Reboot
sudo reboot

# Shutdown
sudo shutdown -h now

# Check temperature
vcgencmd measure_temp

# Check voltage/throttling
vcgencmd get_throttled

# System info
cat /proc/cpuinfo
```

### Network Commands
```bash
# Show IP address
hostname -I

# WiFi info
iwconfig wlan0

# Network config
sudo nano /etc/dhcpcd.conf

# Restart networking
sudo systemctl restart networking
```

### Audio Commands
```bash
# List audio devices
aplay -l

# Test audio
speaker-test -c2 -t wav

# Volume control
alsamixer

# Set default audio device
sudo nano /etc/asound.conf
```

### Serial/Modbus Commands
```bash
# List serial ports
ls -l /dev/tty*

# Enable serial
sudo raspi-config
# Interface Options → Serial

# Install Modbus
pip3 install pymodbus --break-system-packages

# Test Modbus
python3 test_modbus.py
```

### Node-RED Commands
```bash
# Start Node-RED
node-red

# Stop Node-RED
node-red-stop

# Service status
sudo systemctl status nodered

# Restart service
sudo systemctl restart nodered

# View logs
sudo journalctl -u nodered -f
```

---

**Good luck with your dry-run! Take your time, test thoroughly, and don't rush. A successful dry-run means a smooth installation!**