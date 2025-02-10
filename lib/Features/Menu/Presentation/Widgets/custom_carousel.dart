import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, String>> imageUrls = [
    {
      "productName": "Honey Pancakes",
      "imageUrl":
          "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=600",
    },
    {
      "productName": "Schezwan Noodles",
      "imageUrl":
          "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=600",
    },
    {
      "productName": "Butter Naan",
      "imageUrl":
          "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?auto=compress&cs=tinysrgb&w=600",
    },
    {
      "productName": "Schezwan Noodles",
      "imageUrl":
      "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=600",
    },
  ];

  CarouselWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130.0,
        // Height of the carousel
        autoPlay: true,
        // Enable auto-play
        enlargeCenterPage: true,
        // Enlarge the current item
        aspectRatio: 16 / 9,
        // Aspect ratio
        autoPlayInterval: Duration(seconds: 3),
        // Auto-play interval
        viewportFraction: 0.45, // Width of the visible item
      ),
      items: imageUrls.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                // Image with border radius
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(item["imageUrl"]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Bottom Black Overlay with Item Name
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3), // Slight black background
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      item["productName"]!, // Replace with the actual key for the item's name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );

          },
        );
      }).toList(),
    );
  }
}
