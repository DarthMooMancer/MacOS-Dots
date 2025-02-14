#!/bin/bash

echo "🔄 Uninstalling Rust..."
rustup self uninstall -y

echo "🧹 Removing leftover Rust files..."
rm -rf ~/.cargo ~/.rustup

if command -v brew &>/dev/null; then
    echo "🍺 Checking for Homebrew installation of Rust..."
    brew list rust &>/dev/null && brew uninstall rust
fi

echo "✅ Rust completely removed."

echo "🔄 Reinstalling Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "🔄 Restarting shell..."
exec "$SHELL"

echo "✅ Rust installed! Verifying installation..."
rustc --version && cargo --version && rustup --version

echo "🔄 Installing Nightly Rust..."
rustup install nightly

echo "⚙️  Setting nightly as the default toolchain..."
rustup default nightly

echo "🔄 Setting up Blink.Cmp (if installed)..."
BLINK_CMP_PATH="$HOME/.local/share/nvim/site/pack/deps/opt/blink.cmp"

if [ -d "$BLINK_CMP_PATH" ]; then
    cd "$BLINK_CMP_PATH" || exit
    rustup override set nightly
    echo "🚀 Building Blink.Cmp with nightly..."
    cargo +nightly build --release
else
    echo "⚠️  Blink.Cmp directory not found, skipping build."
fi

echo "✅ Rust reset and reinstalled successfully!"

