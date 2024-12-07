import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/screens/reg_login/registration_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/patrik.jpeg',
      'assets/images/115895.560x420.jpg',
      'assets/images/photo_2024-02-25_14-42-04.jpg',
    ];
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          // Слайдер
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: double.infinity, // Автоматически адаптируется
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1, // Полный размер элемента
              ),
              items: imgList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Кнопка
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(25),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
