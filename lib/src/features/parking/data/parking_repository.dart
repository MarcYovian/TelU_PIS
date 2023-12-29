import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class ParkingRepository {
  final DatabaseReference _databaseReference;

  ParkingRepository(this._databaseReference);

  Future<Map> getParkingOverview() async {
    try {
      final dataRef = await _databaseReference.child('smart_parking/blocks');
      Map<dynamic, dynamic> parkingOverview = {
        'totalSpots': 0,
        'availableSpots': 0,
        'occupiedSpots': 0,
      };

      List<Map<dynamic, dynamic>> allData = [];

      await dataRef.onChildChanged.forEach((DatabaseEvent event) {
        // Reset values before recalculating
        // parkingOverview['availableSpots'] = 0;
        // parkingOverview['occupiedSpots'] = 0;
        print(event.snapshot.value as Map);
        for (final child in event.snapshot.children) {
          final a = child.child("A").value as Map;
          final b = child.child("B").value as Map;
          allData.add(a);
          allData.add(b);
          parkingOverview['availableSpots'] += a['isFilled'] ? 0 : 1;
          parkingOverview['availableSpots'] += b['isFilled'] ? 0 : 1;
          parkingOverview['occupiedSpots'] += a['isFilled'] ? 1 : 0;
          parkingOverview['occupiedSpots'] += b['isFilled'] ? 1 : 0;
        }
      });

      parkingOverview['totalSpots'] = allData.length;

      // print(parkingOverview);
      return parkingOverview;
    } on Exception catch (e) {
      return {"error": e};
    }
  }

  // Fungsi lain yang mungkin diperlukan, seperti update status isFilled.
}
