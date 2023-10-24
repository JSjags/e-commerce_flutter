import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({Key? key}) : super(key: key);

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final List<String> slides = [
    "https://i.ibb.co/6DTnkBv/We-are-everywhere-Look-around-and-shop.png",
    "https://i.ibb.co/Pmnv7nY/We-are-everywhere-Look-around-and-shop-1.png",
    "https://i.ibb.co/hmPqdWy/We-are-everywhere-Look-around-and-shop-2.png",
    "https://i.ibb.co/dgVcNqk/We-are-everywhere-Look-around-and-shop-3.png",
    "https://i.ibb.co/6Pv1vdg/We-are-everywhere-Look-around-and-shop-4.png"
  ];
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            clipBehavior: Clip.none,
              height: 190.0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayCurve: Curves.easeInOutExpo,
              enlargeFactor: 0.25,
              onPageChanged: (index, reason) {
                setState(() {
                  currentSlide = index;
                });
              }),
          items: slides.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    boxShadow: i == slides[currentSlide] ? const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ] : [],
                      gradient: const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.network(i, fit: BoxFit.fill, )),
                );
              },
            );
          }).toList(),
        ),
        AnimatedSmoothIndicator(
          activeIndex: currentSlide,
          count: slides.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 5,
            activeDotColor: Color(0xffE80011),
            dotColor: Colors.grey
          ),
        )
      ],
    );
  }
}
