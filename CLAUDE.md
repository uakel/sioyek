# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sioyek is a PDF viewer with a focus on textbooks and research papers. It's built with Qt 5/6 and uses MuPDF as the PDF rendering library. The application supports advanced features like smart jumping, bookmarks, highlights, portals, and SyncTeX integration.

## Build System and Commands

### Dependencies
- Qt 5 or Qt 6 (with qmake in PATH)
- libharfbuzz-dev
- Platform-specific dependencies (see README.md for details)

### Build Commands

**Linux:**
```bash
./build_linux.sh
```
This script:
- Compiles MuPDF with system harfbuzz
- Uses qmake to configure the project with linux_app_image config
- Creates a build/ directory with the compiled binary and necessary files

**macOS:**
```bash
# Prerequisites: brew install qt@5 freeglut mesa harfbuzz
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
MAKE_PARALLEL=8 ./build_mac.sh [portable]
```
This script:
- Compiles MuPDF
- Uses qmake with optional non_portable config
- Creates sioyek.app bundle in build/ directory
- Can create DMG and signed application

**Quick macOS build and install:**
```bash
./one_command_build.sh
```
Simplified script that builds and installs to /Applications with code signing.

**Clean build:**
```bash
./delete_build.sh  # If this script exists
# Or manually: rm -rf build mupdf/build
```

### Development Workflow
1. Make changes to source files in pdf_viewer/
2. Run appropriate build script for your platform
3. Test the application from the build/ directory

## Project Architecture

### Core Components

**pdf_viewer/** - Main application source directory containing:
- `main.cpp` - Application entry point and Qt setup
- `main_widget.h/cpp` - Primary application window and UI coordination
- `document.h/cpp` - PDF document handling and management
- `document_view.h/cpp` - Document viewing logic and viewport management
- `pdf_view_opengl_widget.h/cpp` - OpenGL-based PDF rendering widget
- `pdf_renderer.h/cpp` - PDF rendering interface with MuPDF
- `input.h/cpp` - Keyboard and mouse input handling
- `config.h/cpp` - Configuration file parsing and management
- `ui.h/cpp` - User interface components and dialogs
- `database.h/cpp` - SQLite database for bookmarks, highlights, and history

**Key Features Implementation:**
- `book.h/cpp` - Book/document metadata and state management
- `coordinates.h/cpp` - Document coordinate system transformations
- `checksum.h/cpp` - File integrity and change detection
- `path.h/cpp` - Cross-platform file path utilities
- `utils.h/cpp` - General utility functions
- `new_file_checker.h/cpp` - File system monitoring
- `synctex/` - SyncTeX integration for LaTeX documents

### Configuration System

**Configuration files (in pdf_viewer/):**
- `prefs.config` - Default application preferences
- `prefs_user.config` - User-customizable preferences
- `keys.config` - Default keybindings
- `keys_user.config` - User-customizable keybindings

User config files override defaults. The application looks for these files in:
- Application directory (portable mode)
- Platform-specific config directories (non-portable mode)

### Dependencies

**MuPDF Integration:**
- `mupdf/` - Complete MuPDF library (PDF rendering engine)
- Built as static libraries: libmupdf, libmupdf-third, libmupdf-threads
- Includes third-party dependencies (zlib, harfbuzz, freetype, etc.)

**Qt Framework:**
- Uses Qt OpenGL widgets for rendering
- Qt 6 compatibility with conditional compilation (#ifdef SIOYEK_QT6)
- Core modules: core, opengl, gui, widgets, network, 3dinput

### Build Configuration

**qmake project file:** `pdf_viewer_build_config.pro`
- Platform-specific configurations (win32, unix:!mac, mac)
- Conditional compilation based on Qt version
- Library linking configuration for MuPDF and system libraries

**Build modes:**
- `portable` - Self-contained application bundle
- `non_portable` - Uses system paths for configuration and resources
- `linux_app_image` - Special configuration for AppImage builds

### Key Features

**Smart Navigation:**
- Smart jump to references and figures without PDF links
- Table of contents navigation with search
- Marks and bookmarks system (local and global)
- Portal system for multi-monitor setups

**Document Management:**
- Quick open with file history
- Database-backed bookmark and highlight storage
- SyncTeX support for LaTeX integration
- Configurable key bindings and preferences

## Development Notes

- C++17 standard required
- OpenGL-based rendering for performance
- Cross-platform file path handling
- Extensive customization through config files
- SQLite database for persistent storage
- Thread-safe file monitoring and checking