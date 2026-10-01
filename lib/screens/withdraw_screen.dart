import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  final int userCoins;
  const WithdrawScreen({super.key, required this.userCoins});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'UPI';

  void _submitWithdrawal() {
    final String paymentId = _upiController.text.trim();
    final String amountStr = _amountController.text.trim();

    if (paymentId.isEmpty || amountStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kripya saari details bharein!')),
      );
      return;
    }

    int requestedCoins = int.tryParse(amountStr) ?? 0;

    if (requestedCoins < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum withdrawal 500 coins (₹5) hai!')),
      );
      return;
    }

    if (requestedCoins > widget.userCoins) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aapke paas itne coins nahi hain!')),
      );
      return;
    }

    // Success Message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181829),
        title: const Text('Request Submitted!', style: TextStyle(color: Colors.green)),
        content: Text(
          'Aapki ₹${(requestedCoins / 100).toStringAsFixed(2)} ki withdrawal request mil gayi hai. 24 ghante me payment ho jayega.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFF6C5CE7))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Cash'),
        backgroundColor: const Color(0xFF181829),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181829),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Available Balance', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.userCoins} Coins (≈ ₹${(widget.userCoins / 100).toStringAsFixed(2)})',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Payment Method Choose Karein', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('UPI ID')),
                    selected: _selectedPaymentMethod == 'UPI',
                    selectedColor: const Color(0xFF6C5CE7),
                    onSelected: (selected) {
                      setState(() => _selectedPaymentMethod = 'UPI');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Paytm Number')),
                    selected: _selectedPaymentMethod == 'Paytm',
                    selectedColor: const Color(0xFF6C5CE7),
                    onSelected: (selected) {
                      setState(() => _selectedPaymentMethod = 'Paytm');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input Fields
            TextField(
              controller: _upiController,
              decoration: InputDecoration(
                labelText: _selectedPaymentMethod == 'UPI' ? 'Enter UPI ID (e.g. example@upi)' : 'Enter Paytm Number',
                filled: true,
                fillColor: const Color(0xFF181829),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Coins to Redeem (Min 500 Coins)',
                filled: true,
                fillColor: const Color(0xFF181829),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitWithdrawal,
                child: const Text('Redeem Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}