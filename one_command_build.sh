#!/bin/zsh

export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
MAKE_PARALLEL=8 ./build_mac.sh
mv build/sioyek.app /Applications/
sudo codesign --force --sign - --deep /Applications/sioyek.app
)
