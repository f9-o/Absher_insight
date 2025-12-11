import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:local_auth/local_auth.dart';
import 'mock_data.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isAuthenticated = false;
  bool isScanning = false;
  bool _isObscured = true;
  final LocalAuthentication auth = LocalAuthentication();

  late Timer _timer;
  int _timeLeft = 30;
  double _progressValue = 1.0;
  String _currentQRData = InsightService.encryptedQRData;

  @override
  void dispose() {
    if (isAuthenticated) _timer.cancel();
    super.dispose();
  }

  void _startLiveQR() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _progressValue = _timeLeft / 30;
        } else {
          _timeLeft = 30;
          _progressValue = 1.0;
          _currentQRData = "${InsightService.encryptedQRData}_${DateTime.now().second}";
        }
      });
    });
  }

  void authenticate() async {
    setState(() { isScanning = true; });
    try {
      await Future.delayed(const Duration(seconds: 1));
      bool didAuthenticate = true;

      if (didAuthenticate) {
        setState(() {
          isScanning = false;
          isAuthenticated = true;
        });
        _startLiveQR();
      }
    } catch (e) {
      setState(() { isScanning = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007A5E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("المحفظة الآمنة", style: GoogleFonts.cairo(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: isAuthenticated ? _buildDigitalID() : _buildSecurityCheck(),
      ),
    );
  }

  Widget _buildSecurityCheck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 80, color: Colors.white.withOpacity(0.5)),
        const SizedBox(height: 20),
        Text("التحقق من الهوية", style: GoogleFonts.cairo(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text("مطلوب المصادقة الحيوية للوصول", style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 50),
        isScanning
        ? const CircularProgressIndicator(color: Colors.white)
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF007A5E),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: authenticate,
            icon: const Icon(Icons.face),
            label: Text("فتح المحفظة", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildDigitalID() {
    return ZoomIn(
      child: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isObscured ? 1.0 : 0.0,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
              child: Text("اضغط مطولاً لإظهار البيانات", style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
            ),
          ),
          GestureDetector(
            onLongPressStart: (_) {
              setState(() { _isObscured = false; });
            },
            onLongPressEnd: (_) {
              setState(() { _isObscured = true; });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 620,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 10))],
              ),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _isObscured ? 10.0 : 0.0,
                  sigmaY: _isObscured ? 10.0 : 0.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.verified_user, color: Colors.green, size: 30),
                        Text("الهوية الوطنية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF007A5E))),
                        const Icon(Icons.flag, color: Colors.green),
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      children: [
                        Container(
                          width: 80, height: 100,
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.person, size: 50, color: Colors.grey),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("لينا أحمد", style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("ID: 1010XXXXXX", style: GoogleFonts.cairo(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: _timeLeft < 10 ? Colors.red : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: QrImageView(
                            data: _currentQRData,
                            version: QrVersions.auto,
                            size: 180.0,
                            foregroundColor: const Color(0xFF007A5E),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            backgroundColor: Colors.grey[200],
                            color: _timeLeft < 10 ? Colors.red : const Color(0xFF007A5E),
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.refresh, size: 14, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text("يتجدد الرمز تلقائياً خلال $_timeLeft ثانية", style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}