import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/base/base_response.dart';

void main() {
  group('BaseResponse', () {
    test('maps the API envelope, exposing `result` as `data`', () {
      final response = BaseResponse.fromJson({
        'status': true,
        'message': 'OK',
        'code': 200,
        'result': [
          {'id': 1},
        ],
      });

      expect(response.status, isTrue);
      expect(response.message, 'OK');
      expect(response.code, 200);
      expect(response.data, [
        {'id': 1},
      ]);
      expect(response.haveError(), isFalse);
    });

    test('flags non-200 codes as errors', () {
      final response = BaseResponse.fromJson({
        'status': false,
        'message': 'Unauthenticated',
        'code': 401,
        'result': null,
      });

      expect(response.haveError(), isTrue);
      expect(response.data, isNull);
    });
  });
}
