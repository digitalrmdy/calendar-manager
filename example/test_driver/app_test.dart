import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// no main code allowed here
void main() {
  group('Calender Manager', () {
    late FlutterDriver driver;
    final addEventFinder = find.byValueKey('addEvent');
    final loadingFinder = find.byValueKey('loading');

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      try {
        driver.close();
      } catch (e) {
        print(e);
      }
    });

    setUp(() {});

    test('Add event succcess', () async {
      await driver.tap(addEventFinder);
      await Future.delayed(Duration(milliseconds: 10000));
    });
  });
}
