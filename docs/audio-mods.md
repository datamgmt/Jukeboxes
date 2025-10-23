# How-To: Modify Jukebox Audio Signal Path with Mixer Integration

## Overview
This guide explains how to cut the internal audio cable between the jukebox pre-amp and main amp, add RCA connectors, and integrate a LINKFOR Passive Stereo Mixer with a Behringer UCA202 USB Audio Interface.

## Purpose
This modification allows you to:
- Inject external audio sources (Raspberry Pi) into the jukebox
- Maintain original jukebox functionality
- Switch between or mix multiple audio sources
- Connect to external devices via USB audio interface

---

## ⚠️ Safety Warnings

**CRITICAL SAFETY STEPS:**
1. **UNPLUG THE JUKEBOX** from mains power before starting
2. Discharge any capacitors in the amplifier circuit
3. Wait at least 15 minutes after unplugging before working inside
4. Use insulated tools
5. Keep the area dry and well-lit
6. Take photos before cutting anything

---

## Required Tools

### Cutting and Stripping
- Wire cutters/cable cutters
- Wire strippers (for appropriate gauge)
- Sharp knife or cable jacket stripper
- Multimeter (for testing continuity)

### Soldering
- Soldering iron (25-40W)
- Solder (60/40 rosin core)
- Helping hands/PCB holder
- Solder sucker or desoldering braid
- Heat shrink tubing (various sizes)
- Heat gun or lighter

### General
- Masking tape and marker (for labeling)
- Isopropyl alcohol and cotton swabs
- Cable ties
- Electrical tape

---

## Required Materials

- **4x RCA male plugs** (metal shell type recommended)
- **LINKFOR Passive Stereo Mixer** (2-channel or appropriate model)
- **Behringer UCA202 USB Audio Interface**
- **RCA cables** (2 pairs minimum for connections)
- **Heat shrink tubing** (assorted sizes)
- **Cable management clips** (optional)

---

## Step-by-Step Instructions

### Phase 1: Preparation and Planning

#### 1. Document the Existing Setup
```
□ Take clear photos of all wiring
□ Label the existing cable with tape
□ Identify pre-amp output location
□ Identify main amp input location
□ Note wire colors and connections
□ Create a wiring diagram
```

#### 2. Verify the Cable
- Use multimeter to confirm which cable connects pre-amp to main amp
- Test continuity from pre-amp output to amp input
- Confirm stereo configuration (left/right channels)
- Measure cable gauge (typically 18-22 AWG for audio)

#### 3. Determine Cut Location
**Optimal cut point considerations:**
- Leave at least 6-8 inches of cable on each end for working room
- Choose location with easy access for future maintenance
- Avoid areas with sharp edges or heat sources
- Ensure room for RCA plugs and strain relief

---

### Phase 2: Cutting and Preparing the Cable

#### 4. Power Down and Safety Check
```
□ Unplug jukebox from wall outlet
□ Remove any fuses
□ Wait 15+ minutes
□ Test with multimeter for residual voltage
□ Discharge capacitors if present (consult amp documentation)
```

#### 5. Mark and Cut the Cable
1. Mark the cut point with masking tape on both sides
2. Label each side:
   - "TO PRE-AMP" on the pre-amp side
   - "TO MAIN AMP" on the amp side
3. Make a clean, straight cut with wire cutters
4. Take a photo of the cut cable ends

#### 6. Strip the Cable Jacket
For each cable end (repeat for both):

1. Strip back outer jacket 1.5-2 inches
2. Identify conductors:
   - Shielded cable: Hot, Ground, Shield
   - Unshielded stereo: Left Hot, Left Ground, Right Hot, Right Ground
3. Strip individual conductors 1/4 inch (6mm)
4. Twist stranded wire ends tightly

**Common Wire Color Codes:**
- Red/White = Right/Left audio signal
- Bare/Shield = Ground
- Black = Common ground

---

### Phase 3: Installing RCA Plugs

#### 7. Prepare RCA Plugs

For EACH of the 4 RCA plugs needed:

1. Disassemble the RCA plug
   - Remove outer metal shell
   - Identify center pin and ground tabs
   
2. Thread components onto cable BEFORE soldering:
   - Slide outer shell onto cable first
   - Add strain relief spring/collar
   - Add insulating sleeve

#### 8. Solder RCA Connections

**For Shielded Cable (per channel):**

1. **Center Pin (Signal/Hot):**
   - Tin the center conductor
   - Insert into center pin terminal
   - Apply heat and flow solder
   - Hold steady until cool

2. **Ground/Shield:**
   - Twist shield wires together
   - Tin the shield bundle
   - Solder to ground tabs on RCA plug body
   - Ensure no shield strands touch center pin

3. **Insulation:**
   - Slide heat shrink over center pin connection
   - Apply heat to shrink
   - Check for shorts with multimeter

4. **Assembly:**
   - Slide outer shell back over connection
   - Crimp or screw shell tight
   - Test connection with multimeter

**Repeat for all 4 RCA plugs:**
- Pre-amp Left Out → RCA plug
- Pre-amp Right Out → RCA plug
- Main Amp Left In → RCA plug
- Main Amp Right In → RCA plug

---

### Phase 4: Testing Connections

#### 9. Continuity Testing

Use multimeter in continuity mode:

**Pre-Amp Side:**
```
□ Test center pin to pre-amp output (should beep)
□ Test shield to pre-amp ground (should beep)
□ Test center pin to shield (should NOT beep - no short)
□ Repeat for both left and right channels
```

**Main Amp Side:**
```
□ Test center pin to amp input (should beep)
□ Test shield to amp ground (should beep)
□ Test center pin to shield (should NOT beep)
□ Repeat for both left and right channels
```

#### 10. Visual Inspection
```
□ All solder joints shiny and solid (not cold or blobby)
□ No loose wire strands
□ Heat shrink properly covering exposed connections
□ RCA plug shells properly seated
□ All labels still in place
```

---

### Phase 5: Connecting to LINKFOR Mixer

#### 11. LINKFOR Mixer Setup

**Understanding the Mixer:**
- The LINKFOR is a passive mixer (no power required)
- Typically has 2 stereo inputs and 1 stereo output
- Each channel may have individual volume control

**Connection Plan:**
```
INPUT 1: Jukebox Pre-Amp (original audio source)
INPUT 2: Behringer UCA202 (Raspberry Pi/external audio)
OUTPUT: To Jukebox Main Amp
```

#### 12. Connect Pre-Amp to Mixer

**Required:** 1 pair of RCA cables (male-to-male)

1. Connect pre-amp LEFT RCA plug to mixer INPUT 1 LEFT (white/left)
2. Connect pre-amp RIGHT RCA plug to mixer INPUT 1 RIGHT (red/right)
3. Set INPUT 1 volume to 70% as starting point
4. Label this connection: "JUKEBOX PRE-AMP"

#### 13. Connect Mixer to Main Amp

**Required:** 1 pair of RCA cables (male-to-male)

1. Connect mixer OUTPUT LEFT to main amp LEFT RCA plug (white)
2. Connect mixer OUTPUT RIGHT to main amp RIGHT RCA plug (red)
3. Set master volume to 80% as starting point
4. Label this connection: "TO MAIN AMP"

---

### Phase 6: Integrating Behringer UCA202

#### 14. Connect UCA202 to Mixer

**Required:** 1 pair of RCA cables (male-to-male)

The Behringer UCA202 has:
- USB connection (input from computer/Raspberry Pi)
- RCA output jacks (red/white)
- Headphone jack (not needed)

**Connection:**
1. Connect UCA202 OUTPUT LEFT to mixer INPUT 2 LEFT (white)
2. Connect UCA202 OUTPUT RIGHT to mixer INPUT 2 RIGHT (red)
3. Set INPUT 2 volume to 70% as starting point
4. Label this connection: "RASPBERRY PI"

#### 15. Connect UCA202 to Raspberry Pi

1. Plug UCA202 USB cable into Raspberry Pi USB port
2. The Pi should auto-detect the device
3. Configure as default audio output in Pi settings:
   ```bash
   # Check if detected
   aplay -l
   
   # Should show: USB Audio Device
   ```

---

### Phase 7: Cable Management

#### 16. Organize Cables

1. **Secure loose cables** with cable ties
2. **Route cables away from:**
   - High voltage mains wiring
   - Amplifier heat sinks
   - Moving mechanical parts
3. **Use cable management clips** to attach to jukebox frame
4. **Leave some slack** for future access and maintenance
5. **Keep mixer accessible** for volume adjustments

#### 17. Position Equipment

**Mixer Placement:**
- Mount in accessible location
- Allow room for cable connections
- Keep away from heat sources
- Consider adding mounting bracket

**UCA202 Placement:**
- Near Raspberry Pi USB connection
- Away from high-voltage areas
- Accessible for future device swapping
- Consider using double-sided tape or Velcro

---

### Phase 8: Testing and Verification

#### 18. Initial Power-Up Test

**BEFORE applying power:**
```
□ Verify all connections secure
□ Check no loose wires or shorts
□ Ensure mixer volumes at safe levels (50-70%)
□ Main amp volume at minimum
□ All labels in place
```

**Power-up sequence:**
1. Plug in jukebox
2. Turn on power
3. Listen for unusual sounds (buzzing, humming)
4. Slowly increase amp volume

#### 19. Test Original Jukebox Audio

**Test the jukebox pre-amp path:**
1. Play a record on jukebox
2. Mixer INPUT 1 volume at 70%
3. Mixer master volume at 80%
4. Main amp at normal listening level
5. Verify both channels working
6. Adjust volumes as needed

**Listen for:**
- Clean, clear audio
- No distortion
- No hum or buzz
- Balanced left/right
- Normal volume levels

#### 20. Test Raspberry Pi Audio

**Test the UCA202/Pi path:**
1. Mute/lower INPUT 1 on mixer
2. Raise INPUT 2 volume to 70%
3. Play audio from Raspberry Pi (Spotify, etc.)
4. Verify both channels working
5. Adjust volumes as needed

**Listen for:**
- Clean, clear audio
- No USB noise or interference
- Proper stereo separation
- Volume comparable to jukebox

#### 21. Test Mixed Audio

**Test both sources simultaneously:**
1. Set both INPUT 1 and INPUT 2 to 50%
2. Play jukebox record
3. Play Raspberry Pi audio simultaneously
4. Both should be audible and mixed
5. Adjust individual volumes as desired

---

### Phase 9: Fine-Tuning and Optimization

#### 22. Level Matching

**Goal:** Match volume levels between jukebox and Pi

1. Play reference audio on jukebox (mid-volume record)
2. Note mixer input and master levels
3. Play same audio on Raspberry Pi
4. Adjust INPUT 2 to match jukebox level
5. Mark optimal settings with tape/label

**Recommended Starting Points:**
- Jukebox (INPUT 1): 70-80%
- Raspberry Pi (INPUT 2): 60-70%
- Mixer Master: 80%
- Main Amp: Per preference

#### 23. Raspberry Pi Audio Configuration

**Optimize Pi audio output for UCA202:**

```bash
# Set UCA202 as default output
sudo nano /etc/asound.conf
```

Add:
```
defaults.pcm.card 1
defaults.ctl.card 1
```

**Test audio:**
```bash
speaker-test -c2 -t wav
```

**Adjust software volume:**
```bash
alsamixer
# Set to 90-100% for cleanest signal
```

#### 24. Ground Loop Check

**If you hear hum or buzz:**

**Troubleshooting:**
1. Try plugging everything into same power strip
2. Use ground loop isolators if needed
3. Ensure all shields properly connected
4. Keep audio cables away from power cables
5. Check for damaged cables

---

## Wiring Diagram

```
┌─────────────┐
│  JUKEBOX    │
│  PRE-AMP    │
│             │
│  L ●  R ●   │ (RCA plugs added here)
└──┬────┬─────┘
   │    │
   │    │  RCA Cables
   │    │
   ▼    ▼
┌─────────────────────────────┐
│  LINKFOR STEREO MIXER       │
│                             │
│  INPUT 1: L● ●R (Jukebox)   │
│  INPUT 2: L● ●R (Pi/UCA202) │
│                             │
│  OUTPUT:  L● ●R             │
└──────────┬─────┬────────────┘
           │     │
           │     │  RCA Cables
           │     │
           ▼     ▼
      ┌─────────────┐
      │  RCA Plugs  │ (Added to original amp cable)
      └──┬────┬─────┘
         │    │
         ▼    ▼
    ┌─────────────┐
    │  JUKEBOX    │
    │  MAIN AMP   │
    └─────────────┘

┌──────────────────┐
│  BEHRINGER       │     ┌────────────────┐
│  UCA202          │     │  RASPBERRY PI  │
│                  │USB  │                │
│  L● ●R           ├─────┤  ● USB Port    │
└──┬────┬──────────┘     └────────────────┘
   │    │
   │    │  RCA Cables
   │    │
   └────┴───── To MIXER INPUT 2
```

---

## Troubleshooting

### No Sound from Jukebox
- Check INPUT 1 volume not muted
- Verify pre-amp RCA connections
- Test continuity of cables
- Check main amp getting signal

### No Sound from Raspberry Pi
- Check INPUT 2 volume not muted
- Verify UCA202 USB connection
- Check Pi audio settings
- Test UCA202 with headphones

### Distortion or Clipping
- Reduce mixer input volumes
- Lower mixer master volume
- Check pre-amp output level not too high
- Verify proper impedance matching

### Hum or Buzz
- Check ground loop issues
- Ensure all shields connected
- Separate audio from power cables
- Try different power outlet

### One Channel Missing
- Test RCA cable with multimeter
- Check solder joints on affected channel
- Verify mixer input not faulty
- Test with different RCA cable

### Imbalanced Volume
- Adjust individual channel volumes
- Check cable connections
- Test speaker connections
- Verify amp channel balance

---

## Maintenance and Future Modifications

### Regular Checks
- Monthly: Check all connections tight
- Quarterly: Clean RCA contacts
- Annually: Inspect solder joints
- As needed: Test all audio paths

### Potential Upgrades
- Add ground loop isolator if needed
- Upgrade to powered mixer for more control
- Add additional sources to mixer inputs
- Install remote volume control
- Add LED indicators for active source

### Documentation
- Keep wiring diagram updated
- Note any setting changes
- Save these instructions in jukebox
- Take photos of final installation

---

## Component Information

### LINKFOR Passive Stereo Mixer
- No power required (passive design)
- Multiple inputs to single output
- Individual channel volume controls
- Typical frequency response: 20Hz-20kHz

### Behringer UCA202
- USB 1.1/2.0 compatible
- 16-bit/48kHz audio resolution
- Plug-and-play (no drivers needed on Pi)
- Stereo RCA outputs
- Low latency audio

---

## Final Checklist

```
□ All safety precautions followed
□ Cable cut cleanly and labeled
□ 4 RCA plugs properly soldered
□ All connections tested for continuity
□ No shorts detected
□ Pre-amp connected to mixer INPUT 1
□ UCA202 connected to mixer INPUT 2
□ Mixer output connected to main amp
□ UCA202 USB connected to Raspberry Pi
□ All cables neatly routed and secured
□ Jukebox audio tested and working
□ Raspberry Pi audio tested and working
□ Mixed audio tested and working
□ Volume levels balanced and marked
□ All components properly mounted
□ Documentation complete
□ Photos taken of final setup
```

---

## Additional Notes

**Tips for Success:**
- Take your time with soldering - cold joints cause problems
- Use quality RCA plugs with solid metal shells
- Keep wires short to minimize interference
- Label everything clearly
- Test each step before moving forward

**When to Seek Help:**
- If uncomfortable working with electrical components
- If jukebox has tube amplifier (high voltage)
- If unusual smells, smoke, or sounds occur
- If connections don't test properly

---

**Document Version:** 1.0  
**Last Updated:** [Date]  
**Created for:** Jukebox Raspberry Pi Integration Project