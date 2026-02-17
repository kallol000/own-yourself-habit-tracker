import 'package:own_yourself/utils/types.dart';

List<String> habitTimeOptions(HabitRepetitionType type) {
  switch(type) {
    case HabitRepetitionType.weekly:
    return List.generate(6, (index) => '${index + 1}');
    default:
    return List.generate(29, (index) => '${index + 1}');
  }
  
}

