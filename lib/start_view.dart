import 'package:collegecoin/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'login_view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageSlideshow(
              /// Width of the [ImageSlideshow].
              width: double.infinity,

              /// Height of the [ImageSlideshow].
              height: 550,

              /// The page to show when first creating the [ImageSlideshow].
              initialPage: 0,

              /// The color to paint the indicator.
              indicatorColor: Colors.blue,

              /// The color to paint behind th indicator.
              indicatorBackgroundColor: Colors.grey,

              /// Called whenever the page in the center of the viewport changes.
              onPageChanged: (value) {
                print('Page changed: $value');
              },

              /// Auto scroll interval.
              /// Do not auto scroll with null or 0.
              autoPlayInterval: 3000,

              /// Loops back to first slide.
              isLoop: true,

              /// The widgets to display in the [ImageSlideshow].
              /// Add the sample image file into the images folder
              children: [
                Image.asset(
                  'assets/imgslid1hd1.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/imgslid2hd2.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/imgslid3hd3.png',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login'),
            ),
          ),
          SizedBox(
            width: 300,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple[700],
                backgroundColor: Colors.blueGrey[50],
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}