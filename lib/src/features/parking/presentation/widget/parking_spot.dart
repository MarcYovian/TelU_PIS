import 'package:flutter/material.dart';

class ParkingSpot extends StatelessWidget {
  final String block;
  final String spot;
  final bool data;
  final bool isLeft;
  final double height;
  final double imageHeight;
  final double spotFontSize;
  final FontWeight spotFontWeight;

  const ParkingSpot({
    super.key,
    this.block = "",
    this.spot = "",
    this.data = false,
    required this.isLeft,
    required this.height,
    required this.imageHeight,
    required this.spotFontSize,
    required this.spotFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    bool isFilled = data;
    bool isBlockA = (block == "A");

    return isFilled
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.black26, width: 0),
                left: isBlockA
                    ? const BorderSide(color: Colors.black26, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black26, width: 2),
                top: const BorderSide(color: Colors.black26, width: 1.5),
              ),
            ),
            child: Center(
              child: isLeft
                  ? RotatedBox(
                      quarterTurns: -2,
                      child: Image(
                        image: const AssetImage("assets/images/red_car.png"),
                        alignment: Alignment.center,
                        height: imageHeight,
                      ),
                    )
                  : Image(
                      image: const AssetImage("assets/images/red_car.png"),
                      alignment: Alignment.center,
                      height: imageHeight,
                    ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width / 2 - 53,
            height: height,
            decoration: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.black26, width: 0),
                left: isBlockA
                    ? const BorderSide(color: Colors.black26, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black26, width: 2),
                top: const BorderSide(color: Colors.black26, width: 0),
              ),
            ),
            child: Center(
              child: Text(
                '$block - $spot',
                style: TextStyle(
                  fontSize: spotFontSize,
                  fontWeight: spotFontWeight,
                  color: const Color(0xFFFC1037),
                ),
              ),
            ),
          );
  }
}
