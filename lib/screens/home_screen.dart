import 'package:flutter/material.dart';
import '../services/admob_service.dart';
import 'withdraw_screen.dart';
import 'refer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 250;
  final AdMobService _adMobService = AdMobService();
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // AdMob Load Karo
    _adMobService.loadRewardedAd(
      onAdLoaded: () {
        setState(() {
          _isAdLoaded = true;
        });
      },
    );
  }

  void _watchAd() {
    if (_isAdLoaded) {
      _adMobService.showRewardedAd(
        onUserEarnedReward: (rewardAmount) {
          setState(() {
            _coins += rewardAmount;
            _isAdLoaded = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mubarak ho! +$rewardAmount Coins mil gaye!')),
          );
          // Agla ad load karo
          _adMobService.loadRewardedAd(
            onAdLoaded: () => setState(() => _isAdLoaded = true),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad load ho raha hai, 2 second rukne ke baad try karein...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Cash', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('Total Balance', style: TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        '$_coins Coins',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '≈ ₹${(_coins / 100).toStringAsFixed(2)} INR',
                    style: const TextStyle(fontSize: 16, color: Colors.white90, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Earn Coins',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Watch Ads Task
            _buildTaskTile(
              icon: Icons.play_circle_fill,
              color: Colors.redAccent,
              title: 'Watch Ads & Earn',
              subtitle: 'Watch video ads to get +10 coins each',
              onTap: _watchAd,
            ),
            const SizedBox(height: 12),

            // Refer & Earn Task
            _buildTaskTile(
              icon: Icons.people_alt,
              color: Colors.green,
              title: 'Refer & Earn',
              subtitle: 'Invite friends & get 500 bonus coins',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReferScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Withdraw Task
            _buildTaskTile(
              icon: Icons.account_balance_wallet,
              color: Colors.orangeAccent,
              title: 'Withdraw Money',
              subtitle: 'Redeem your coins to Paytm/UPI',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawScreen(userCoins: _coins),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF181829),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
