// To be replaced with a l10n library eventually.
final t = (
  app: (title: "Remote Rift"),

  connection: (
    connectingTitle: "Connecting...",
    connectingDescription: "Initializing communication with the game client.",
    connectedTitle: "Connected",
    connectedDescription: "Successfully connected to the game client.",
    errorTitle: "Connection error",
    errorDescription: "Unable to connect to the game client.",
    errorRetry: "Reconnect",
  ),

  gameError: (
    unableToConnectTitle: "Unable to connect",
    unknownTitle: "Unknown game state",
    unableToConnectDescription:
        "The game client could not be reached. Make sure that it is running to interact with the game.",
    unknownDescription: "The game's state could not be accessed due to an unexpected error.",
  ),
);
