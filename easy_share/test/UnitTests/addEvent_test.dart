import 'package:easy_share/Screens/EventsHandler/add_event.page.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('empty field returns error string', (){
    var results =  TextFieldValidator.validate('');
    expect(results, "This field can't be empty!");
  });

  test('empty field returns error string', (){
    var results =  TextFieldValidator.validate('Random String');
    expect(results, null);
  });
}
