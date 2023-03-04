import 'package:flutter/material.dart';

class LoadingImage extends StatefulWidget {
  const LoadingImage({super.key});

  @override
  LoadingImageState createState() => LoadingImageState();
}

class LoadingImageState extends State<LoadingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/fpt_logosvg.png',
              fit: BoxFit.cover,
              width: 200,
              height: 100,
            ),
            SizedBox(
              width: 60,
              height: 60,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 5,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
