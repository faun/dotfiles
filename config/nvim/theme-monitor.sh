#!/usr/bin/env bash

# Ensure cache directory exists
CACHE_DIR="$HOME/.cache/nvim"
THEME_FILE="$CACHE_DIR/theme_mode"
mkdir -p "$CACHE_DIR"

# Function to detect theme on macOS
detect_macos_theme() {
    if defaults read -g AppleInterfaceStyle &>/dev/null; then
        echo "dark"
    else
        echo "light"
    fi
}

# Function to detect theme on Linux
detect_linux_theme() {
    # Try GNOME
    if command -v gsettings >/dev/null 2>&1; then
        scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        if [[ $scheme == *"dark"* ]]; then
            echo "dark"
            return
        elif [[ $scheme == *"light"* ]]; then
            echo "light"
            return
        fi
    fi
    
    # Try KDE
    if command -v kreadconfig5 >/dev/null 2>&1; then
        scheme=$(kreadconfig5 --group "General" --key "ColorScheme" 2>/dev/null)
        if [[ $scheme == *"[Dd]ark"* ]]; then
            echo "dark"
            return
        elif [[ $scheme == *"[Ll]ight"* ]]; then
            echo "light"
            return
        fi
    fi
    
    # Try COLORFGBG environment variable
    if [ -n "$COLORFGBG" ]; then
        bg=${COLORFGBG##*;}  # Get background color
        if [ "$bg" -gt 8 ]; then
            echo "dark"
            return
        else
            echo "light"
            return
        fi
    fi
    
    # Default fallback
    echo "dark"
}

# Function to detect theme on Windows
detect_windows_theme() {
    local theme
    theme=$(reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme 2>/dev/null)
    if [[ $theme == *"0x0"* ]]; then
        echo "dark"
    else
        echo "light"
    fi
}

# Function to get current theme based on OS
get_theme_state() {
    case "$(uname -s)" in
        Darwin*)
            detect_macos_theme
            ;;
        Linux*)
            detect_linux_theme
            ;;
        MINGW*|CYGWIN*|MSYS*)
            detect_windows_theme
            ;;
        *)
            echo "dark"  # Default fallback
            ;;
    esac
}

# Function to notify Neovim instances
notify_neovim() {
    case "$(uname -s)" in
        MINGW*|CYGWIN*|MSYS*)
            # Windows handling
            tasklist | grep -i "nvim" | awk '{print $2}' | xargs -I{} taskkill /PID {} /F
            ;;
        *)
            # Unix-like systems
            pgrep nvim | xargs -I{} kill -SIGUSR1 {} 2>/dev/null
            ;;
    esac
}

# Main monitoring loop
while true; do
    current_theme=$(get_theme_state)
    
    # Read previous theme
    previous_theme=""
    if [ -f "$THEME_FILE" ]; then
        previous_theme=$(cat "$THEME_FILE")
    fi
    
    # If theme changed, update file and notify Neovim
    if [ "$current_theme" != "$previous_theme" ]; then
        echo "$current_theme" > "$THEME_FILE"
        notify_neovim
    fi
    
    sleep 1
done
