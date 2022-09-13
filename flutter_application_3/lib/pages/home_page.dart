import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async'; // support for async programming with classes such as future and stream
import 'dart:io'
    show
        Platform; // porvides information such as os,hostname,enviroment variables
import 'package:location_permissions/location_permissions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterReactiveBle =
      FlutterReactiveBle(); //instance of bluetooth created
  bool _scanStarted = false;
  late DiscoveredDevice _ubiqueDevice;
  // late StreamSubscription<DiscoveredDevice> _scanStream;
  final List<DiscoveredDevice> devicesList = [];

  String _deviceMsg = "";
  bool _foundDeviceWaitingToConnect = false;
  void _startScan() async {
// Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
// Main scanning logic happens here ⤵️
    if (permGranted) {
      flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        // Change this string to what you defined in Zephyr
        setState(() {
          devicesList = device;
          _foundDeviceWaitingToConnect = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Diagnostic App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          _scanStarted
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    child: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {},
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    child: Icon(Icons.search, color: Colors.blue),
                    onPressed: _startScan,
                  ),
                ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              child: Icon(Icons.bluetooth),
              onPressed: () {},
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
