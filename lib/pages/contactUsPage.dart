import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text("🌿 Contact Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We’re here to help and would love to hear from you!",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text("🧠 Have questions?", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            const Text("💡 Got feedback or suggestions?", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            const Text("❗ Need assistance?", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              "Our team is dedicated to making your NatureSync experience smooth and enjoyable.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              "How to Reach Us:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.email_outlined),
                SizedBox(width: 10),
                Text("Email: NatureSync@gmail.com", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.phone_outlined),
                SizedBox(width: 10),
                Text("WhatsApp: +90-555 355 2341", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "✨ Let’s work together to make exploring nature and connecting with others even more meaningful!",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
