import 'package:flutter/material.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/controllers/cart_controller.dart';
import 'package:frontend/services/stripe_service.dart';
import 'package:provider/provider.dart';

class Pay extends StatefulWidget {
  final double amount;
  final String jwtToken;

  const Pay({super.key, this.amount = 29.99, required this.jwtToken});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<void> _payNow() async {
    if (_isProcessing) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name.')));
      return;
    }

    final cartController = context.read<CartController>();

    setState(() {
      _isProcessing = true;
    });

    try {
      await StripeService.makePayment(widget.jwtToken);

      cartController.clear();

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "Payment successful! Your order is being processed.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.myRed),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.inputField.withValues(alpha: 0.35),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final processingText = _isProcessing ? "Processing..." : "Pay Now";
    final amount = widget.amount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Finalize Payment",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.myBeige,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.myRed, Color(0xFFB71C1C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.myRed.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SLICE IT",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "**** **** **** ****",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Card Holder',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                _nameController.text.isEmpty
                                    ? "Full Name"
                                    : _nameController.text.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.credit_card, color: Colors.white54),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Billing Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration(
                    label: "Card Holder",
                    hint: "Enter your full name",
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Please enter your name"
                      : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Note: You will safely introduce card's details through Stripe's secure payment",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.myBeige.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _PriceRow(label: "Total Amount", amount: amount),
                      const SizedBox(height: 8),
                      const _PriceRow(label: "Delivery Fee", amount: 0.00),
                      const Divider(height: 30),
                      _PriceRow(
                        label: "Amount to Pay",
                        amount: amount,
                        highlight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _payNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            '$processingText - \$${amount.toStringAsFixed(2)} RON',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool highlight;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: highlight ? 18 : 15,
      fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
      color: highlight ? AppColors.myRed : Colors.black87,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text("\$${amount.toStringAsFixed(2)} RON", style: style),
      ],
    );
  }
}
