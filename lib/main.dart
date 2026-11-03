import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BangladeshRailwayApp());
}

const Color navy = Color(0xFF102D50);
const Color blue = Color(0xFF174A80);
const Color paleBlue = Color(0xFFE8F1FC);
const String mapStyle = 'https://tiles.openfreemap.org/styles/liberty';

class BangladeshRailwayApp extends StatelessWidget {
  const BangladeshRailwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bangladesh Railway',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapLibreMapController? _mapController;
  bool _is3D = true;
  bool _mapReady = false;
  bool _showInfo = true;
  String _mapMessage = 'মানচিত্র লোড হচ্ছে…';

  // Demo coordinate near Dhaka. This is NOT a verified live train location.
  static const LatLng demoTrain = LatLng(23.8103, 90.4125);
  static const List<LatLng> demoRoute = [
    LatLng(23.8103, 90.4125),
    LatLng(23.9000, 90.3800),
    LatLng(24.1000, 90.3500),
  ];

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _mapController = controller;
  }

  Future<void> _onStyleLoaded() async {
    if (!mounted) return;
    try {
      await _mapController?.addLine(
        LineOptions(
          geometry: demoRoute,
          lineColor: '#1976D2',
          lineWidth: 4.0,
          lineOpacity: 0.9,
        ),
      );
      await _mapController?.addSymbol(
        SymbolOptions(
          geometry: demoTrain,
          textField: '🚆',
          textSize: 30,  
          textIgnorePlacement: true,
        ),
      );
      if (mounted) {
        setState(() {
          _mapReady = true;
          _mapMessage = 'ডেমো ট্রেনের অবস্থান';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _mapMessage = 'ম্যাপ চালু আছে; ট্রেন মার্কার যোগ করা যায়নি');
      }
    }
  }

  Future<void> _toggleCamera() async {
    final next3D = !_is3D;
    setState(() => _is3D = next3D);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: demoTrain,
          zoom: 11.8,
          tilt: next3D ? 58 : 0,
          bearing: next3D ? 18 : 0,
        ),
      ),
    );
  }

  Future<void> _recenter() async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: demoTrain,
          zoom: 11.8,
          tilt: _is3D ? 58 : 0,
          bearing: _is3D ? 18 : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: MapLibreMap(
                styleString: mapStyle,
                initialCameraPosition: const CameraPosition(
                  target: demoTrain,
                  zoom: 11.8,
                  tilt: 58,
                  bearing: 18,
                ),
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoaded,
                compassEnabled: false,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
              ),
            ),
            Positioned(
              top: 12,
              left: 14,
              right: 14,
              child: _topBar(),
            ),
            Positioned(
              right: 14,
              top: 92,
              child: Column(
                children: [
                  _mapButton(
                    icon: _is3D ? Icons.view_in_ar : Icons.map_outlined,
                    label: _is3D ? '3D' : '2D',
                    onTap: _toggleCamera,
                  ),
                  const SizedBox(height: 10),
                  _mapButton(
                    icon: Icons.my_location,
                    label: 'কেন্দ্র',
                    onTap: _recenter,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 16,
              child: _bottomPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.train, color: Colors.white, size: 29),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BANGLADESH RAILWAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'বাংলাদেশের ট্রেন এখন আপনার হাতেই',
                  style: TextStyle(color: Color(0xFFD6E8FF), fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.menu, color: Colors.white),
        ],
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 58,
          height: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: blue, size: 23),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: paleBlue, borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.train, color: blue, size: 25),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ডেমো ট্রেন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('ঢাকা এলাকার পরীক্ষামূলক অবস্থান', style: TextStyle(color: Colors.black54, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFF3D9), borderRadius: BorderRadius.circular(20)),
                child: const Text('DEMO', style: TextStyle(color: Color(0xFF946000), fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(_mapReady ? Icons.check_circle : Icons.hourglass_top, color: _mapReady ? Colors.green : Colors.orange, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(_mapMessage, style: const TextStyle(fontSize: 11, color: Colors.black54))),
              TextButton(
                onPressed: () => setState(() => _showInfo = !_showInfo),
                child: Text(_showInfo ? 'লুকান' : 'বিস্তারিত'),
              ),
            ],
          ),
          if (_showInfo)
            const Text(
              'এটি প্রাথমিক UI ও 3D map prototype। এখানে দেখানো ট্রেনের অবস্থান বাস্তব বা লাইভ নয়। পরের ধাপে নির্ভরযোগ্য ট্রেন ডেটা যুক্ত হবে।',
              style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
