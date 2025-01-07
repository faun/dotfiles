# #!/usr/bin/env bash

set -euo pipefail

# Create the LaunchAgents directory if it doesn't exist
mkdir -p ~/Library/LaunchAgents
cat >~/Library/LaunchAgents/me.faun.nvim-theme-monitor.plist <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>me.faun.nvim-theme-monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${HOME}/.config/nvim/theme-monitor.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/nvim-theme-monitor.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/nvim-theme-monitor.error.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
</dict>
</plist>
EOL

# Unload if it exists and load the new one
launchctl unload ~/Library/LaunchAgents/me.faun.nvim-theme-monitor.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/me.faun.nvim-theme-monitor.plist
