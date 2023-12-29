class ParkingBlock {
  final String id;
  final ParkingSpace spaceA;
  final ParkingSpace spaceB;

  ParkingBlock({
    required this.id,
    required this.spaceA,
    required this.spaceB,
  });
}

class ParkingSpace {
  final String id;
  final bool isFilled;

  ParkingSpace({
    required this.id,
    required this.isFilled,
  });
}
