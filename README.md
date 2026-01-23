# Remote Rift Desktop

Desktop application for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

## Overview

Remote Rift Desktop is available for Windows and macOS. It provides a thin wrapper around Remote Rift Connector, allowing the mobile application to access the League client and displaying key service information.

## Architecture

The project is implemented in Flutter, targeting Windows and macOS from a single shared codebase.

### Code structure

The project is organized into the following main layers:

- **UI** - Contains widgets paired with cubits and state classes, where applicable, to manage feature-specific state and logic.

When launched, the application starts the Remote Rift API and registers a service entry via mDNS on the local network. The application then displays a window with the UI and adds an entry to the system tray.

### Dependencies

This section describes selected third-party packages used throughout the application:

- [bloc](https://pub.dev/packages/bloc) - State management using blocs and cubits, providing clear separation of UI and state logic with minimal boilerplate.

- [slang](https://pub.dev/packages/slang) - Localization via strongly typed code generation from YAML files, with support for advanced translation features.
 
## Usage

To run the application on a computer:

1. Download the latest version from the [GitHub releases page](https://github.com/tomwyr/remote-rift-desktop/releases) for your operating system. Builds are available for Windows and macOS.
2. Run the downloaded application. You may need to grant permission to allow communication with devices on your local network.
3. Start the League of Legends client and wait for the connection to be established.

  > [!important]
  > The service API address is resolved automatically and requires the user to be connected to a single network. At the moment, if multiple networks are available, the application will automatically select one network address to use.

## Development

To run the project locally:

1. Ensure Flutter is installed.
2. Run `flutter pub get` to install dependencies.
3. Run `dart run slang` to generate localization source files.
4. Run the application using `flutter run` or an IDE.
5. After modifying source files, restart the application or use hot reload.

### Building project

Run `flutter build windows` or `flutter build macos` to compile the application for the target platform.

### Localization

To update localized strings:

1. Edit the YAML files in `lib/i18n`.
2. Run `dart run slang` to regenerate localization code.
3. Reload the application to apply the changes.

## Related Projects

- [Remote Rift Website](https://github.com/tomwyr/remote-rift-website) - A landing page showcasing the application and guiding users on getting started.
- [Remote Rift Connector](https://github.com/tomwyr/remote-rift-connector) - A local service that connects to and communicates with the League Client API.
- [Remote Rift Mobile](https://github.com/tomwyr/remote-rift-mobile) - A mobile application that allows interaction with the League Client remotely.
- [Remote Rift Foundation](https://github.com/tomwyr/remote-rift-foundation) - A set of shared packages containing common UI, utilities, and core logic used across Remote Rift projects.
