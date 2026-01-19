import 'dart:io';

const _defaultPort = 8080;

Future<ConnectorApiAddress> resolveApiAddress(ConnectorApiAddressSource addressSource) async {
  return switch (addressSource) {
    .environment => _readFromEnvironment(),
    .systemLookup => await _lookupDeviceNetworks(),
  };
}

ConnectorApiAddress _readFromEnvironment() {
  const hostKey = 'API_HOST';
  const host = String.fromEnvironment(hostKey);
  if (host.isEmpty) {
    throw StateError('$hostKey must be provided');
  }

  const portKey = 'API_PORT';
  const portStr = String.fromEnvironment(portKey);
  if (portStr.isEmpty) {
    throw StateError('$portKey must be provided');
  }
  final port = int.tryParse(portStr);
  if (port == null) {
    throw StateError('Invalid $portKey: "$portStr"');
  }

  return (host: host, port: port);
}

Future<ConnectorApiAddress> _lookupDeviceNetworks() async {
  final addresses = <ConnectorApiAddress>[];
  for (var interface in await NetworkInterface.list()) {
    for (var address in interface.addresses) {
      if (address.type == .IPv4 && !address.isLoopback) {
        addresses.add((host: address.address, port: _defaultPort));
      }
    }
  }

  if (addresses.isEmpty) {
    throw StateError('No IPv4 network is connected');
  }
  if (addresses.length > 1) {
    throw StateError('Multiple IPv4 networks are connected');
  }

  return addresses.single;
}

typedef ConnectorApiAddress = ({String host, int port});

enum ConnectorApiAddressSource { environment, systemLookup }
