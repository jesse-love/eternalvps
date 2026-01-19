#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Helper Functions for logging ---
print_info() {
    echo -e "\n\e[34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

print_warning() {
    echo -e "\e[33m[WARNING]\e[0m $1"
}

# --- Ensure script is run as root ---
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo." >&2
    exit 1
fi

# --- 1. System Update & Base Packages ---
print_info "Updating system packages and installing base dependencies..."
apt-get update
apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl gnupg git unzip python3-pip python3-venv pipx btop fzf
print_success "System updated and base packages installed."

# --- 2. Install Docker & Docker Compose ---
print_info "Installing Docker and Docker Compose..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    print_success "Docker and Docker Compose installed."
else
    print_warning "Docker is already installed. Skipping."
fi

# --- 3. Install Node.js v20 (via NodeSource) ---
print_info "Installing Node.js v20..."
if ! command -v node &> /dev/null || [[ $(node -v | cut -d'v' -f2) != "20."* ]]; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    print_success "Node.js v20 installed."
else
    print_warning "Node.js v20 is already installed. Skipping."
fi

# --- 4. Install Development CLIs ---
print_info "Installing Development CLIs: wrangler, neonctl, aider..."

# Install wrangler
if ! command -v wrangler &> /dev/null; then
    npm install -g wrangler
    print_success "Cloudflare Wrangler installed."
else
    print_warning "Wrangler is already installed. Skipping."
fi

# Install neonctl
if ! command -v neonctl &> /dev/null; then
    npm install -g @neondatabase/serverless
    print_success "NeonCTL installed."
else
    print_warning "NeonCTL is already installed. Skipping."
fi

# Install aider-chat
if ! command -v aider &> /dev/null; then
    # Use pipx to install aider in an isolated environment, as per PEP 668
    pipx install aider-chat
    print_success "Aider installed."
else
    print_warning "Aider is already installed. Skipping."
fi

# --- 5. Install Terminal "Pimping" Tools ---
print_info "Installing terminal enhancement tools..."

# Install Starship
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship installed."
else
    print_warning "Starship is already installed. Skipping."
fi

# Install Bat (batcat)
if ! command -v bat &> /dev/null; then
    apt-get install -y bat
    # On Debian, the binary is `batcat`. Create a symlink for `bat`.
    if [ ! -f /usr/local/bin/bat ]; then
        ln -s /usr/bin/batcat /usr/local/bin/bat
    fi
    print_success "Bat installed."
else
    print_warning "Bat is already installed. Skipping."
fi

# Install Eza
if ! command -v eza &> /dev/null; then
    mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    apt-get update
    apt-get install -y eza
    print_success "Eza installed."
else
    print_warning "Eza is already installed. Skipping."
fi

# Install Zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_success "Zoxide installed."
else
    print_warning "Zoxide is already installed. Skipping."
fi

# Install Micro
if ! command -v micro &> /dev/null; then
    curl https://getmic.ro | bash
    mv micro /usr/local/bin/
    print_success "Micro editor installed."
else
    print_warning "Micro is already installed. Skipping."
fi

# Install Tldr
if ! command -v tldr &> /dev/null; then
    npm install -g tldr
    print_success "tldr installed."
else
    print_warning "tldr is already installed. Skipping."
fi


print_info "To complete the setup, add the following to your ~/.bashrc or ~/.zshrc:"
echo '
eval "$(starship init bash)"
eval "$(zoxide init bash)"
alias ls="eza --icons"
alias cat="bat"
alias help="tldr"
'
print_success "Installation script finished!"