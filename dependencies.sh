#!/bin/bash
set -e # Exit immediately on any error

# Function to detect if inside distrobox
is_distrobox() {
  [[ -n "$DISTROBOX_ENTER_PATH" ]] || [[ -n "$IN_DISTROBOX" ]] || [[ -n "$DISTROBOX_ID" ]]
}

# Function to check if Homebrew is installed
check_brew() {
  if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew is not installed."
    read -p "Do you want to install Homebrew now? (y/N): " install_brew
    install_brew=${install_brew,,} # lowercase

    if [[ "$install_brew" == "y" ]]; then
      echo "🍺 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "⚠️  Homebrew installation skipped. Cannot continue."
      exit 1
    fi
  else
    echo "✅ Homebrew is already installed."
  fi
}

# ---- Main Script Execution ----

# Check if inside distrobox
if is_distrobox; then
  echo "⚠️  Warning: Running inside a distrobox container."
else
  echo "✅ Not inside a distrobox container."

  # Prompt the user
  read -p "Are you sure you want to install on your host system? (y/N): " confirm
  confirm=${confirm,,} # to lowercase
  if [[ "$confirm" != "y" ]]; then
    echo "❌ Installation aborted by user."
    exit 1
  fi
fi

# Ensure brew is available
check_brew

# Install system-level zsh
echo "📦 Installing zsh via nala..."
sudo nala install -y zsh

# Install Oh My Zsh
echo "✨ Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Homebrew packages
echo "🍺 Installing Homebrew packages..."

brew install zsh-autosuggestions
brew install git gh
brew install neovim
brew install fzf
brew install bat
brew install eza
brew install fd
brew install ripgrep
brew install thefuck
brew install lazygit
brew install zoxide
brew install zsh-syntax-highlighting

# Install Starship prompt
echo "🚀 Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo "🎉 All installations complete."
