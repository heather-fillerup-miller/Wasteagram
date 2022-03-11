import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post_dto.dart';

void main() {
  test('Empty quantity returns false', () {
    //setup
    var newPost = PostDTO();
    //exercise
    var result = newPost.isValidQuantity("");

    //verify
    expect(result, false);
  });

  test('< 0 quantity returns false', () {
    //setup
    var newPost = PostDTO();
    //exercise
    var result = newPost.isValidQuantity("-1");

    //verify
    expect(result, false);
  });

  test('0 quantity return false', () {
    //setup
    var newPost = PostDTO();
    //exercise
    var result = newPost.isValidQuantity("0");

    //verify
    expect(result, false);
  });

  test('> 0 quantity return true', () {
    //setup
    var newPost = PostDTO();
    //exercise
    var result = newPost.isValidQuantity("1");

    //verify
    expect(result, true);
  });
}
