import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post.dart';

void main() {
  test('Create a Food Waste Post Data Transfer Object with correct values', () {
    //setup
    final date = DateTime.now();
    const url = 'https://test';
    const quantity = 1;
    const lattitude = 33.0;
    const longitude = -96.7;

    //exercise
    Post post = Post(
        createDate: date,
        quantity: quantity,
        latitude: lattitude,
        longitude: longitude,
        imageUrl: url);

    //verify
    expect(post.createDate, date);
    expect(post.quantity, 1);
    expect(post.latitude, 33.0);
    expect(post.longitude, -96.7);
    expect(post.imageUrl, 'https://test');
  });
}
