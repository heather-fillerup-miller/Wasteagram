import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post_dto.dart';

void main() {
  test('Create a Food Waste Post Object with correct values', () {
    //setup
    final date = DateTime.now();
    const url =
        'https://s36700.pcdn.co/wp-content/uploads/2019/04/DSTR-1906-Italian-Greyhound.jpg.webp';
    const quantity = 1;
    const lattitude = 33.0;
    const longitude = -96.7;

    //exercise
    PostDTO post = PostDTO(
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
    expect(post.imageUrl,
        'https://s36700.pcdn.co/wp-content/uploads/2019/04/DSTR-1906-Italian-Greyhound.jpg.webp');
  });
}
