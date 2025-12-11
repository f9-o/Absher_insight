import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mock_data.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predictions = InsightService.getSmartPredictions();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF007A5E),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("مرحباً لينا", style: GoogleFonts.cairo(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text("لديك 3 تنبيهات ذكية اليوم", style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text("المساعد الاستباقي", style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF007A5E))),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final item = predictions[index];
                  return FadeInLeft(
                    delay: Duration(milliseconds: index * 200),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: item['color'].withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))],
                        border: Border.all(color: item['color'].withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: item['color'].withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(item['icon'], color: item['color'], size: 30),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(item['desc'], style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 12)),
                                const SizedBox(height: 10),
                                if (item['days_left'] < 5)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.timer, size: 14, color: Colors.red),
                                        const SizedBox(width: 5),
                                        Text("باقي ${item['days_left']} يوم", style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BounceInUp(
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
          },
          backgroundColor: const Color(0xFF007A5E),
          icon: const Icon(Icons.account_balance_wallet, size: 28),
          label: Text("محفظة أبشر الرقمية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
          elevation: 10,
        ),
      ),
    );
  }
}