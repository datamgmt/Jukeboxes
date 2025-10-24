# Rockola 459 Switch Parallel Wiring to Waveshare Relay Module

## Overview

This guide shows how to wire the 10 selection switches from a Rockola 459 jukebox in parallel with the Waveshare Modbus RTU 16-Ch Relay Module, allowing both manual switch selection AND automated Raspberry Pi control of the same functions.

**Parallel Wiring Concept:**
- Each physical switch and its corresponding relay work together
- Pressing the switch OR activating the relay will trigger the selection
- Both paths lead to the same jukebox control circuit

---

## Component Overview

### Rockola 459 Selection Switches
- **10 switches total:** Numbered 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
- **Switch type:** Momentary SPST (Single Pole Single Throw)
- **Function:** Complete circuit when pressed, selecting a record
- **Original wiring:** Each switch has two terminals

### Waveshare Modbus RTU 16-Ch Relay Module
- **16 relay channels** (we'll use channels 1-10)
- **Relay contacts per channel:**
  - **NO** (Normally Open) - Opens when relay off, closes when relay on
  - **COM** (Common) - The common connection point
  - **NC** (Normally Closed) - Closes when relay off, opens when relay on
- **Control:** Via RS485 Modbus from Raspberry Pi

### Waveshare RS485 CAN HAT
- **Mounted on Raspberry Pi**
- **RS485 terminals:** A+, B-, GND
- **Connection:** Serial communication to relay module

---

## Wiring Diagram

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    RASPBERRY PI 5                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Waveshare RS485 CAN HAT                      │   │
│  │                                                      │   │
│  │         A+        B-        GND                      │   │
│  └──────────┬────────┬─────────┬────────────────────────┘   │
└─────────────┼────────┼─────────┼────────────────────────────┘
              │        │         │
              │RS485   │RS485    │Common
              │A+      │B-       │Ground
              │        │         │
              ▼        ▼         ▼
┌──────────────────────────────────────────────────────────────┐
│    Waveshare Modbus RTU 16-Channel Relay Module              │
│                                                              │
│    RS485 Input:  A(+)    B(-)    GND                         │
│    Power Input:  +12V    GND                                 │
│                                                              │
│    Relay Outputs (Channels 1-10):                            │
│                                                              │
│    CH1:  NO1  COM1  NC1     CH6:  NO6  COM6  NC6             │
│    CH2:  NO2  COM2  NC2     CH7:  NO7  COM7  NC7             │
│    CH3:  NO3  COM3  NC3     CH8:  NO8  COM8  NC8             │
│    CH4:  NO4  COM4  NC4     CH9:  NO9  COM9  NC9             │
│    CH5:  NO5  COM5  NC5     CH10: NO10 COM10 NC10            │
│                                                              │
└──────────────────────────────────────────────────────────────┘
       │      │                           │      │
       │      │                           │      │
       └──────┴───────── ... ─────────────┴──────┘
              │                           │
              │ Parallel wiring to        │
              │ Rockola switches          │
              ▼                           ▼
┌──────────────────────────────────────────────────────────────┐
│               ROCKOLA 459 JUKEBOX                            │
│                                                              │
│    Selection Switches (inside jukebox):                      │
│                                                              │
│    [SW1]  [SW2]  [SW3]  [SW4]  [SW5]                         │
│    [SW6]  [SW7]  [SW8]  [SW9]  [SW0]                         │
│                                                              │
│    Selection Control Circuit                                 │
└──────────────────────────────────────────────────────────────┘
```

---

## Detailed Parallel Wiring Diagram (Per Channel)

### Single Channel Example - Switch 1 / Relay 1

```
                    Rockola 459 Internal Circuit
                    
                    +12V (or Control Voltage)
                         │
                         │
                    ┌────┴────┐
                    │ Control │
                    │ Circuit │
                    │  (CH1)  │
                    └────┬────┘
                         │
                         │ Output to selection mechanism
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        │                │                │
    ┌───▼───┐            │            ┌───▼───┐
    │ SW 1  │            │            │ NO1   │
    │Manual │            │            │Relay 1│
    │Switch │            │            │Contact│
    └───┬───┘            │            └───┬───┘
        │                │                │
        │  (Terminal A)  │  (Terminal B)  │
        └────────────────┴────────────────┘
                         │
                         │
                    ┌────▼────┐
                    │  COM1   │
                    │ Relay 1 │
                    │ Common  │
                    └────┬────┘
                         │
                         ▼
                      Ground

Legend:
• SW1 = Physical switch on Rockola 459
• NO1 = Normally Open contact on Relay Channel 1
• COM1 = Common terminal on Relay Channel 1
• When SW1 pressed OR Relay 1 activated → Circuit completes
```

### Detailed Wiring for All 10 Channels

```
SWITCH MAPPING:
Rockola Switch → Relay Channel
─────────────────────────────────
    1         →      1
    2         →      2
    3         →      3
    4         →      4
    5         →      5
    6         →      6
    7         →      7
    8         →      8
    9         →      9
    0         →     10

WIRING CONFIGURATION (Each Channel):
────────────────────────────────────────────────────────────

Channel 1:
┌─────────────────────────────────────────────────────────┐
│ Rockola SW1 Terminal A → Junction → Relay NO1           │
│ Rockola SW1 Terminal B → Junction → Relay COM1          │
│                                                         │
│ OR (Alternative - see below):                           │
│ Control Circuit → SW1 Terminal A → NO1 → COM1 → Ground  │
└─────────────────────────────────────────────────────────┘

Channel 2:
┌─────────────────────────────────────────────────────────┐
│ Rockola SW2 Terminal A → Junction → Relay NO2           │
│ Rockola SW2 Terminal B → Junction → Relay COM2          │
└─────────────────────────────────────────────────────────┘

Channel 3:
┌─────────────────────────────────────────────────────────┐
│ Rockola SW3 Terminal A → Junction → Relay NO3           │
│ Rockola SW3 Terminal B → Junction → Relay COM3          │
└─────────────────────────────────────────────────────────┘

[... repeat pattern for channels 4-9 ...]

Channel 10:
┌─────────────────────────────────────────────────────────┐
│ Rockola SW0 Terminal A → Junction → Relay NO10          │
│ Rockola SW0 Terminal B → Junction → Relay COM10         │
└─────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Wiring Instructions

### SAFETY FIRST

```
⚠️ CRITICAL SAFETY WARNINGS ⚠️

1. UNPLUG JUKEBOX from mains power before starting
2. Discharge any capacitors (wait 15+ minutes)
3. Take photos of ALL existing wiring before modifications
4. Label every wire you disconnect
5. Test for voltage with multimeter before touching
6. Work with insulated tools only
7. Keep workspace dry and well-lit
```

---

### Phase 1: Preparation and Documentation

#### Step 1: Document Existing Wiring

**Before touching anything:**

1. **Take extensive photos:**
   - Overall view of switch assembly
   - Close-ups of each switch connection
   - Wire routing and colors
   - Any labels or markings

2. **Create a wiring map:**
   ```
   Switch 1 Terminal A: [color]_____ → goes to: _____
   Switch 1 Terminal B: [color]_____ → goes to: _____
   
   Switch 2 Terminal A: [color]_____ → goes to: _____
   Switch 2 Terminal B: [color]_____ → goes to: _____
   
   [... etc for all 10 switches ...]
   ```

3. **Verify switch operation:**
   - Test each switch with multimeter (continuity mode)
   - Note which switches are NO (Normally Open)
   - Confirm switch numbers (1-9, 0)

#### Step 2: Identify Control Circuit

**Determine how switches are wired:**

The Rockola 459 typically uses one of these configurations:

**Configuration A: Common Ground**
```
All switches share common ground wire
Each switch has individual signal wire to control circuit
```

**Configuration B: Common Positive**
```
All switches share common positive voltage
Each switch has individual ground return to control circuit
```

**Configuration C: Matrix Wiring**
```
Switches wired in rows and columns
More complex - may require different approach
```

**Action:** Use multimeter to determine your configuration.

#### Step 3: Prepare Materials

**Gather materials:**
```
□ 20+ wire connectors (appropriate size for wire gauge)
□ Wire nuts or terminal blocks (for junctions)
□ 20-30 feet of hookup wire (18-22 AWG, multiple colors)
□ Heat shrink tubing (assorted sizes)
□ Labels or label maker
□ Wire strippers
□ Small screwdriver set
□ Multimeter
□ Electrical tape
□ Cable ties
□ Notepad for notes
```

**Wire color recommendations:**
- Use consistent color scheme
- Example: Red for "A" side, Black for "B" side
- Or use 10 different colors (one per channel)

---

### Phase 2: Relay Module Preparation

#### Step 4: Mount Relay Module

**Position relay module:**

1. **Location considerations:**
   - Close to switch assembly (minimize wire length)
   - Accessible for maintenance
   - Away from heat sources
   - Secure mounting surface
   - Room for cable management

2. **Mount securely:**
   - Use standoffs or mounting brackets
   - Ensure module is level and stable
   - Allow ventilation around module

3. **Label the relay channels:**
   ```
   Relay 1 → Switch 1
   Relay 2 → Switch 2
   ...
   Relay 10 → Switch 0
   ```

#### Step 5: Prepare Relay Module Terminals

**Pre-wire the relay module:**

1. **Cut and strip wires:**
   - Cut 10 pairs of wires (20 wires total)
   - Length: Distance from relay to switches + 6 inches
   - Strip 1/4" from each end

2. **Label all wires at BOTH ends:**
   ```
   Example labels:
   "SW1-A to NO1"
   "SW1-B to COM1"
   "SW2-A to NO2"
   "SW2-B to COM2"
   ... etc
   ```

3. **Connect wires to relay terminals:**
   
   **For Channel 1:**
   ```
   Wire labeled "SW1-A" → Connect to NO1 terminal
   Wire labeled "SW1-B" → Connect to COM1 terminal
   ```
   
   **Repeat for all 10 channels:**
   ```
   Channel 1: Wire pair to NO1 and COM1
   Channel 2: Wire pair to NO2 and COM2
   Channel 3: Wire pair to NO3 and COM3
   Channel 4: Wire pair to NO4 and COM4
   Channel 5: Wire pair to NO5 and COM5
   Channel 6: Wire pair to NO6 and COM6
   Channel 7: Wire pair to NO7 and COM7
   Channel 8: Wire pair to NO8 and COM8
   Channel 9: Wire pair to NO9 and COM9
   Channel 10: Wire pair to NO10 and COM10
   ```

4. **Secure connections:**
   - Tighten terminal screws firmly
   - Tug test each wire
   - No bare wire visible outside terminal

---

### Phase 3: Connecting to Rockola Switches

#### Step 6: Access Switch Assembly

**Open jukebox to access switches:**

1. Remove any panels necessary to access switches
2. Ensure good lighting
3. Have photos available for reference
4. Keep hardware organized

#### Step 7: Understand Original Wiring

**Trace the existing wiring:**

**Example Original Configuration:**
```
                   Jukebox Control Circuit
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
    [Switch 1]         [Switch 2]    ...  [Switch 10]
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                      Common Ground
```

Each switch completes circuit from control board to ground when pressed.

#### Step 8: Create Parallel Junctions

**For each switch, create a junction point:**

**Method A: Using Terminal Blocks**

1. **Install small terminal block near each switch**
2. **Connect original wiring to terminal:**
   ```
   Original Wire A → Terminal Block Position 1
   Connect TWO wires to Position 1:
     - Wire back to original destination
     - Wire to relay NO terminal
   ```

**Method B: Using Wire Nuts**

1. **For each switch terminal:**
   ```
   Strip original wire (don't disconnect completely)
   Add relay wire to junction
   Twist together
   Secure with wire nut
   Cover with electrical tape
   ```

**Method C: Direct Pigtail Connection**

1. **Disconnect original wire from switch**
2. **Connect three wires together:**
   ```
   Original wire (from control circuit)
   + New wire (to relay)
   + New wire (back to switch)
   = 3-way junction
   ```
3. **Secure junction and insulate**

#### Step 9: Wire Each Channel in Parallel

**Channel-by-channel wiring:**

**For Switch 1 (Channel 1):**

1. **Identify Switch 1 terminals:**
   - Terminal A (typically connects to control circuit)
   - Terminal B (typically connects to ground)

2. **Create parallel connection at Terminal A:**
   ```
   Original wire from control circuit
   + Wire labeled "SW1-A to NO1" (already at NO1)
   + Wire returning to Switch 1 Terminal A
   = Junction at Terminal A
   ```

3. **Create parallel connection at Terminal B:**
   ```
   Original wire to ground/common
   + Wire labeled "SW1-B to COM1" (already at COM1)
   + Wire returning to Switch 1 Terminal B
   = Junction at Terminal B
   ```

4. **Result:**
   - Pressing Switch 1 completes circuit (works as before)
   - Activating Relay 1 also completes circuit
   - Both paths work independently and simultaneously

**Repeat Steps 1-4 for ALL remaining switches (2-10)**

#### Step 10: Alternative Simplified Wiring

**If switches have common ground configuration:**

**Easier approach:**

1. **Identify common ground wire** (connects all switches)
2. **Connect this common ground to ALL relay COM terminals:**
   ```
   Common Ground → Branch to:
     COM1, COM2, COM3, COM4, COM5,
     COM6, COM7, COM8, COM9, COM10
   ```

3. **For each switch signal wire:**
   ```
   Junction Method:
   
   Control Circuit Signal → Junction:
     → Original path to switch
     → New path to relay NO terminal
   ```

This reduces wiring complexity significantly.

---

### Phase 4: Cable Management and Testing

#### Step 11: Organize Wiring

**Clean up the installation:**

1. **Route wires neatly:**
   - Bundle wires together with cable ties
   - Follow existing wire paths when possible
   - Avoid sharp bends or kinks
   - Keep away from moving parts

2. **Secure bundles:**
   - Use cable tie mounts or clips
   - Attach to jukebox frame
   - Leave some slack for service access

3. **Label everything:**
   - Both ends of every wire
   - At relay module terminals
   - At switch junctions
   - Include channel numbers

4. **Protect connections:**
   - Cover all junctions with heat shrink or tape
   - Ensure no bare wire exposed
   - Verify insulation on all connections

#### Step 12: Visual Inspection

**Before applying power:**

```
□ All relay terminal screws tight
□ No bare wire visible anywhere
□ All junctions properly insulated
□ Wires not touching moving parts
□ Wires not near heat sources
□ Labels present and legible
□ Cable ties secure but not over-tightened
□ No loose wire strands
□ Polarity correct (if applicable)
□ All original connections restored
```

#### Step 13: Continuity Testing

**Test with multimeter (power OFF):**

**For each channel (example: Channel 1):**

1. **Test switch alone:**
   ```
   Multimeter in continuity mode
   Probe original circuit points for Switch 1
   Press Switch 1
   Should beep (continuity)
   Release Switch 1
   Should not beep (open circuit)
   ```

2. **Test relay alone:**
   ```
   Multimeter across relay NO1 and COM1
   Should not beep (relay off, normally open)
   
   Manually activate relay (if possible) OR
   Apply power and use software to activate
   Should beep when relay energized
   ```

3. **Test parallel operation:**
   ```
   Multimeter across final circuit points
   Either pressing switch OR activating relay should show continuity
   ```

**Repeat for all 10 channels**

#### Step 14: Function Test (No Power)

**Verify all mechanical connections:**

```
□ Channel 1: Switch 1 and Relay 1 parallel - PASS/FAIL
□ Channel 2: Switch 2 and Relay 2 parallel - PASS/FAIL
□ Channel 3: Switch 3 and Relay 3 parallel - PASS/FAIL
□ Channel 4: Switch 4 and Relay 4 parallel - PASS/FAIL
□ Channel 5: Switch 5 and Relay 5 parallel - PASS/FAIL
□ Channel 6: Switch 6 and Relay 6 parallel - PASS/FAIL
□ Channel 7: Switch 7 and Relay 7 parallel - PASS/FAIL
□ Channel 8: Switch 8 and Relay 8 parallel - PASS/FAIL
□ Channel 9: Switch 9 and Relay 9 parallel - PASS/FAIL
□ Channel 10: Switch 0 and Relay 10 parallel - PASS/FAIL
```

---

### Phase 5: Power-Up and Live Testing

#### Step 15: Initial Power-Up

**Power up sequence:**

1. **Connect relay module power supply** (12V DC)
   - Verify correct polarity
   - Plug in relay module only
   - Check power LED

2. **Connect RS485 communication:**
   ```
   RS485 HAT → Relay Module
   A+ → A(+)
   B- → B(-)
   GND → GND
   ```

3. **Power up Raspberry Pi**
   - Boot system
   - Verify Node-RED running
   - Test Modbus communication

4. **Test relays from software:**
   ```
   In Node-RED:
   Click "Relay 1 ON" → Listen for click, check LED
   Click "Relay 1 OFF" → Listen for click, check LED
   Repeat for all 10 relays
   ```

#### Step 16: Manual Switch Testing

**Test original functionality (jukebox powered):**

⚠️ **WARNING: JUKEBOX IS NOW POWERED - BE CAREFUL**

1. **Power up jukebox**
2. **Test each switch manually:**
   ```
   Press Switch 1 → Should select record 1
   Press Switch 2 → Should select record 2
   ... etc
   Press Switch 0 → Should select record 10
   ```

3. **Verify:**
   ```
   □ All switches work as before modification
   □ No degraded performance
   □ Clean activation (no chattering)
   □ Proper selection indicated
   ```

**If any switch fails:** Power down, check wiring at that channel.

#### Step 17: Relay Control Testing

**Test automated control (jukebox powered):**

⚠️ **WARNING: JUKEBOX IS POWERED**

1. **From Raspberry Pi/Node-RED:**
   ```
   Activate Relay 1 → Should select record 1
   Wait for selection to complete
   Deactivate Relay 1
   
   Activate Relay 2 → Should select record 2
   Wait for selection to complete
   Deactivate Relay 2
   
   ... etc for all 10 channels
   ```

2. **Verify:**
   ```
   □ Each relay activation selects correct record
   □ Jukebox responds identically to switch press
   □ No interference between manual and automated
   □ Clean operation, no spurious activations
   ```

#### Step 18: Parallel Operation Test

**Test switch AND relay simultaneously:**

1. **Activate Relay 1** (hold on)
2. **While relay active, press Switch 1**
3. **Release Switch 1**
4. **Deactivate Relay 1**

**Expected result:**
- Circuit remains closed throughout
- Jukebox selection mechanism activates once
- No issues with both paths active

**Repeat test for 2-3 channels to verify**

#### Step 19: Rapid Switching Test

**Test relay speed and reliability:**

1. **Create rapid sequence in Node-RED:**
   ```
   Relay 1 ON → 0.5s delay → OFF
   Relay 2 ON → 0.5s delay → OFF
   Relay 3 ON → 0.5s delay → OFF
   ... etc
   ```

2. **Run sequence multiple times**

3. **Verify:**
   ```
   □ All relays activate correctly
   □ No missed activations
   □ Jukebox responds to each
   □ No mechanical issues
   ```

---

### Phase 6: Final Verification and Documentation

#### Step 20: Complete System Test

**Final comprehensive test:**

1. **Manual mode:**
   - Press all 10 switches in sequence
   - Verify correct selections

2. **Automated mode:**
   - Activate all 10 relays in sequence via Pi
   - Verify correct selections

3. **Mixed mode:**
   - Alternate between manual and automated
   - Verify seamless operation

4. **Long-term test:**
   - Run automated sequence for 30+ minutes
   - Monitor for any issues
   - Check for overheating

#### Step 21: Measure Timing

**Record timing for sequences:**

```
Manual switch press to selection start: _____ ms
Relay activation to selection start: _____ ms
Should be identical or very close
```

**Document any differences**

#### Step 22: Final Documentation

**Create installation record:**

```
INSTALLATION RECORD
===================

Date: __________
Installer: __________

WIRING DETAILS:
- Wire gauge used: _____ AWG
- Wire colors used: _____
- Junction method: Terminal blocks / Wire nuts / Other
- Relay module location: _____

CHANNEL MAPPING VERIFIED:
□ Channel 1 = Switch 1
□ Channel 2 = Switch 2
□ Channel 3 = Switch 3
□ Channel 4 = Switch 4
□ Channel 5 = Switch 5
□ Channel 6 = Switch 6
□ Channel 7 = Switch 7
□ Channel 8 = Switch 8
□ Channel 9 = Switch 9
□ Channel 10 = Switch 0

TESTING RESULTS:
Manual switches: PASS / FAIL
Relay control: PASS / FAIL
Parallel operation: PASS / FAIL
Timing match: PASS / FAIL

PHOTOS TAKEN:
□ Before modification
□ During wiring
□ After completion
□ Relay module installation
□ Cable routing

NOTES:
_________________________________________________
_________________________________________________
_________________________________________________
```

#### Step 23: Create Wiring Schematic

**Draw final as-built schematic:**

1. Update diagram with actual wire colors
2. Note any deviations from plan
3. Include component locations
4. Mark any special considerations
5. Store with jukebox documentation

---

## Detailed Wiring Schematic (Reference)

### Complete 10-Channel Parallel Wiring

```
┌───────────────────────────────────────────────────────────────────┐
│                      ROCKOLA 459 JUKEBOX                          │
│                                                                   │
│  Control Circuit (inside jukebox control board)                   │
│                                                                   │
│    CH1  CH2  CH3  CH4  CH5  CH6  CH7  CH8  CH9  CH10              │
│     │    │    │    │    │    │    │    │    │    │                │
│     ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼                │
│   ┌─────────────────────────────────────────────┐                 │
│   │        Selection Switch Assembly            │                 │
│   │                                             │                 │
│   │  [SW1] [SW2] [SW3] [SW4] [SW5]              │                 │
│   │  [SW6] [SW7] [SW8] [SW9] [SW0]              │                 │
│   │                                             │                 │
│   └──┬───┬───┬───┬───┬───┬───┬───┬───┬───┬──────┘                 │
│      │   │   │   │   │   │   │   │   │   │                        │
└──────┼───┼───┼───┼───┼───┼───┼───┼───┼───┼────────────────────────┘
       │   │   │   │   │   │   │   │   │   │
       │   │   │   │   │   │   │   │   │   │ Each switch has
       │   │   │   │   │   │   │   │   │   │ two wires creating
       │   │   │   │   │   │   │   │   │   │ a parallel junction
       ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼
   ┌─────────────────────────────────────────────────┐
   │           JUNCTION POINTS                       │
   │  (Where original switch wiring splits to        │
   │   maintain original function AND add relay)     │
   │                                                 │
   │  J1  J2  J3  J4  J5  J6  J7  J8  J9  J10        │
   │  ╱\  ╱\  ╱\  ╱\  ╱\  ╱\  ╱\  ╱\  ╱\  ╱\         │
   │ │  ││  ││  ││  ││  ││  ││  ││  ││  ││  │        │
   └─┼──┼┼──┼┼──┼┼──┼┼──┼┼──┼┼──┼┼──┼┼──┼┼──┼────────┘
     │  ││  ││  ││  ││  ││  ││  ││  ││  ││  │
     │  │└──│└──│└──│└──│└──│└──│└──│└──│└──│┘
     │  │   │   │   │   │   │   │   │   │   │
     │  │   │   │   │   │   │   │   │   │   │ New wires to
     │  │   │   │   │   │   │   │   │   │   │ relay module
     ▼  ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼
┌──────────────────────────────────────────────────────────┐
│  Waveshare Modbus RTU 16-Channel Relay Module            │
│                                                          │
│  NO1 COM1   NO2 COM2   NO3 COM3   NO4 COM4   NO5 COM5    │
│   •   •     •   •     •   •     •   •     •   •          │
│   │   │     │   │     │   │     │   │     │   │          │  
│  NO6 COM6   NO7 COM7   NO8 COM8   NO9 COM9   NO10 COM10  │
│   •   •     •   •     •   •     •   •     •   •          │
│   │   │     │   │     │   │     │   │     │   │          │
│                                                          │
│  RS485: A(+) B(-) GND                                    │
│          │   │    │                                      │
└──────────┼───┼────┼──────────────────────────────────────┘
           │   │    │
           │   │    │ RS485 connection
           ▼   ▼    ▼
    ┌──────────────────────┐
    │ Waveshare RS485 HAT  │
    │ (on Raspberry Pi)    │
    │  A+   B-   GND       │
    └──────────────────────┘
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: Switch doesn't work after modification

**Possible causes:**
1. Junction not properly made
2. Wire came loose from terminal
3. Short circuit at junction point

**Solutions:**
1. Check continuity from control circuit through switch
2. Verify all connections tight
3. Test switch in isolation (disconnect relay wire temporarily)
4. Check for shorts with multimeter

#### Issue: Relay activates but jukebox doesn't respond

**Possible causes:**
1. Relay contact not making good connection
2. Wrong NO/NC terminal used
3. Insufficient relay contact current rating
4. Timing too fast

**Solutions:**
1. Verify relay actually closing (test with multimeter)
2. Check using NO (Normally Open) terminal, not NC
3. Verify relay rated for jukebox circuit current
4. Add delay between relay activations (0.5-1 second minimum)

#### Issue: Both switch and relay active cause problems

**Possible causes:**
1. Control circuit sensitive to impedance change
2. Ground loop issue
3. Voltage drop from added wiring

**Solutions:**
1. Add small resistor in series with relay contact
2. Ensure all grounds properly connected
3. Use heavier gauge wire
4. Check for proper isolation between channels

#### Issue: Intermittent operation

**Possible causes:**
1. Loose connection
2. Vibration causing intermittent contact
3. Corroded terminals
4. Cold solder joint (if soldered)

**Solutions:**
1. Check and retighten all terminals
2. Add strain relief to wiring
3. Clean and treat connections with contact cleaner
4. Reflow solder joints

#### Issue: One or more relays don't activate

**Possible causes:**
1. Relay module not powered
2. RS485 communication issue
3. Wrong Modbus address
4. Faulty relay on module

**Solutions:**
1. Verify 12V power to relay module
2. Check RS485 wiring (A-A, B-B)
3. Verify Node-RED configuration
4. Test relay module independently

---

## Testing Checklist

### Pre-Power Testing
```
□ All connections visually inspected
□ No shorts detected with multimeter
□ All junctions properly insulated
□ Wiring secured and labeled
□ Photos taken for documentation
□ Original wiring paths verified
□ Continuity test passed (all channels)
```

### Initial Power Testing
```
□ Relay module power LED on
□ No smoke or burning smell
□ RS485 communication verified
□ All relay LEDs respond to commands
□ All relays click audibly
```

### Manual Switch Testing
```
□ Switch 1 works → Selects record 1
□ Switch 2 works → Selects record 2
□ Switch 3 works → Selects record 3
□ Switch 4 works → Selects record 4
□ Switch 5 works → Selects record 5
□ Switch 6 works → Selects record 6
□ Switch 7 works → Selects record 7
□ Switch 8 works → Selects record 8
□ Switch 9 works → Selects record 9
□ Switch 0 works → Selects record 10
```

### Relay Control Testing
```
□ Relay 1 activates → Selects record 1
□ Relay 2 activates → Selects record 2
□ Relay 3 activates → Selects record 3
□ Relay 4 activates → Selects record 4
□ Relay 5 activates → Selects record 5
□ Relay 6 activates → Selects record 6
□ Relay 7 activates → Selects record 7
□ Relay 8 activates → Selects record 8
□ Relay 9 activates → Selects record 9
□ Relay 10 activates → Selects record 10
```

### Parallel Operation Testing
```
□ Manual and automated control work independently
□ No interference when both paths active
□ Timing matches original operation
□ No spurious activations
```

### Final System Verification
```
□ All 10 channels function correctly
□ Manual switches preserved
□ Automated control working
□ Documentation complete
□ Ready for integration with full system
```

---

## Safety Notes

### During Installation
- Always disconnect power before working on wiring
- Use insulated tools
- Verify no voltage present before touching wires
- One circuit at a time - don't rush
- Take breaks - fatigue causes mistakes

### During Testing
- Start with low power if possible
- Monitor for overheating
- Have fire extinguisher nearby
- Never bypass safety interlocks
- Test thoroughly before closing panels

### Long-Term Maintenance
- Periodically check connection tightness
- Watch for signs of corrosion
- Monitor relay operation hours
- Keep spare relays on hand
- Document any repairs or modifications

---

## Appendix: Relay Module Terminal Guide

### Understanding Relay Contacts

```
NC (Normally Closed):
- Closed when relay is OFF (de-energized)
- Opens when relay is ON (energized)
- Use for circuits that need to be BROKEN when activated

COM (Common):
- The common terminal
- Always connects to either NC or NO depending on relay state
- Connect to one side of the circuit

NO (Normally Open):
- Open when relay is OFF (de-energized)
- Closes when relay is ON (energized)
- Use for circuits that need to be COMPLETED when activated
- THIS IS WHAT WE USE for jukebox switches
```

### Relay Ratings

**Waveshare 16-Ch Relay Module typical specs:**
- Contact rating: 10A @ 250VAC / 10A @ 30VDC
- Coil voltage: 12VDC
- Response time: ~10ms
- Mechanical life: 10,000,000 operations
- Electrical life: 100,000 operations (at rated load)

**For Rockola 459:**
- Switch circuit typically low voltage (6-24V DC)
- Low current (< 100mA typically)
- Well within relay ratings
- Should provide many years of reliable operation

---

