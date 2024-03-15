import 'package:flutter/material.dart';
import 'package:perpustakaan/models/content_model.dart';
import 'package:perpustakaan/screens/auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: contents.titlesDescriptionsAndImages.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage =
                    (index == contents.titlesDescriptionsAndImages.length - 1);
              });
            },
            itemBuilder: (_, i) {
              String title = contents.titlesDescriptionsAndImages[i]["title"]!;
              String description =
                  contents.titlesDescriptionsAndImages[i]["description"]!;
              String image = contents.titlesDescriptionsAndImages[i]["image"]!;
              String background =
                  contents.titlesDescriptionsAndImages[i]["background"]!;

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(background),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      if (image.isNotEmpty)
                        Image.asset(
                          image,
                          height: 170,
                        ),
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ErasBoldItc',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 30),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'ErasBoldItc',
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AuthPage();
                      }));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'ErasBoldItc'),
                    ),
                  ),
                  SmoothPageIndicator(
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.blueAccent,
                      dotColor: Colors.white,
                    ),
                    controller: _controller,
                    count: contents.titlesDescriptionsAndImages.length,
                  ),
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AuthPage();
                            }));
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'ErasBoldItc'),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'ErasBoldItc'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
