#!/bin/bash
# WiFi Setup Utility Installer
# Run this script on a fresh Raspberry Pi to enable first-boot AP mode

set -e

echo "Installing WiFi Setup Utility..."

# Install required packages
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y hostapd dnsmasq python3-flask python3-pip

# Stop services
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Create configuration directory
sudo mkdir -p /etc/wifi-setup
sudo mkdir -p /var/www/wifi-setup

# Create the main Python web server
cat << 'EOF' | sudo tee /var/www/wifi-setup/app.py
#!/usr/bin/env python3
from flask import Flask, render_template_string, request, jsonify
import subprocess
import os
import time

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>WiFi Setup</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            background: #f0f0f0;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #45a049;
        }
        .scan-btn {
            background: #2196F3;
        }
        .scan-btn:hover {
            background: #0b7dda;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 WiFi Setup</h1>
        <div id="message" class="message"></div>
        
        <div class="form-group">
            <button class="scan-btn" onclick="scanNetworks()">Scan for Networks</button>
        </div>
        
        <form id="wifiForm" onsubmit="submitForm(event)">
            <div class="form-group">
                <label for="ssid">Network Name (SSID):</label>
                <input type="text" id="ssid" name="ssid" list="networks" required>
                <datalist id="networks"></datalist>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit">Connect to Network</button>
        </form>
    </div>

    <script>
        function showMessage(msg, type) {
            const msgDiv = document.getElementById('message');
            msgDiv.className = 'message ' + type;
            msgDiv.textContent = msg;
            msgDiv.style.display = 'block';
        }

        function scanNetworks() {
            showMessage('Scanning for networks...', 'info');
            fetch('/scan')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const datalist = document.getElementById('networks');
                        datalist.innerHTML = '';
                        data.networks.forEach(network => {
                            const option = document.createElement('option');
                            option.value = network;
                            datalist.appendChild(option);
                        });
                        showMessage(`Found ${data.networks.length} networks`, 'success');
                    } else {
                        showMessage('Error scanning networks: ' + data.error, 'error');
                    }
                })
                .catch(error => {
                    showMessage('Error: ' + error, 'error');
                });
        }

        function submitForm(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            const data = Object.fromEntries(formData);
            
            showMessage('Connecting to network...', 'info');
            
            fetch('/connect', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Successfully connected! Rebooting...', 'success');
                    setTimeout(() => {
                        showMessage('You can now disconnect from this AP. The device will be on your main network.', 'info');
                    }, 3000);
                } else {
                    showMessage('Error: ' + data.error, 'error');
                }
            })
            .catch(error => {
                showMessage('Error: ' + error, 'error');
            });
        }
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/scan')
def scan():
    try:
        result = subprocess.run(['sudo', 'iwlist', 'wlan0', 'scan'], 
                              capture_output=True, text=True, timeout=10)
        networks = set()
        for line in result.stdout.split('\n'):
            if 'ESSID:' in line:
                ssid = line.split('ESSID:')[1].strip().strip('"')
                if ssid:
                    networks.add(ssid)
        return jsonify({'success': True, 'networks': sorted(list(networks))})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

@app.route('/connect', methods=['POST'])
def connect():
    try:
        data = request.json
        ssid = data.get('ssid')
        password = data.get('password')
        
        # Create wpa_supplicant configuration
        wpa_config = f"""
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={{
    ssid="{ssid}"
    psk="{password}"
    key_mgmt=WPA-PSK
}}
"""
        
        # Write configuration
        with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'w') as f:
            f.write(wpa_config)
        
        # Mark as configured
        with open('/etc/wifi-setup/configured', 'w') as f:
            f.write('1')
        
        # Schedule reboot
        subprocess.Popen(['sudo', 'shutdown', '-r', '+1'])
        
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

sudo chmod +x /var/www/wifi-setup/app.py

# Create hostapd configuration
cat << 'EOF' | sudo tee /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=RaspberryPi-Setup
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=raspberry
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Create dnsmasq configuration
cat << 'EOF' | sudo tee /etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
domain=local
address=/setup.local/192.168.4.1
EOF

# Create startup script
cat << 'EOF' | sudo tee /usr/local/bin/wifi-setup-check.sh
#!/bin/bash

# Check if already configured
if [ -f /etc/wifi-setup/configured ]; then
    echo "Already configured, starting in client mode"
    sudo systemctl stop hostapd
    sudo systemctl stop dnsmasq
    sudo systemctl start wpa_supplicant
    exit 0
fi

echo "First boot detected, starting AP mode"

# Configure static IP for AP mode
sudo ip addr flush dev wlan0
sudo ip addr add 192.168.4.1/24 dev wlan0

# Start services
sudo systemctl start dnsmasq
sudo systemctl start hostapd

# Start web interface
cd /var/www/wifi-setup
sudo python3 app.py
EOF

sudo chmod +x /usr/local/bin/wifi-setup-check.sh

# Create systemd service
cat << 'EOF' | sudo tee /etc/systemd/system/wifi-setup.service
[Unit]
Description=WiFi Setup Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/wifi-setup-check.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable service
sudo systemctl daemon-reload
sudo systemctl enable wifi-setup.service

# Disable default hostapd and dnsmasq from starting automatically
sudo systemctl disable hostapd
sudo systemctl disable dnsmasq

echo ""
echo "Installation complete!"
echo ""
echo "On first boot, the Raspberry Pi will create a WiFi network:"
echo "  SSID: RaspberryPi-Setup"
echo "  Password: raspberry"
echo ""
echo "Connect to this network and navigate to:"
echo "  http://192.168.4.1"
echo "  or"
echo "  http://setup.local"
echo ""
echo "Reboot now to test: sudo reboot"