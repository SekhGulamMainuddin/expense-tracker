import 'package:remixicon/remixicon.dart';
import 'dart:mirrors';

void main() {
  // This might not work in all environments, but let's try to inspect the class members
  // Alternatively, just a dummy check to see if common names exist
  print('Checking Remix icons...');
  try {
    print('car_fill: ${Remix.car_fill}');
    print('car_line: ${Remix.car_line}');
    print('fitness: NOT FOUND in compiler output');
  } catch (e) {
    print('Error: $e');
  }
}
