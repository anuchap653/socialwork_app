import 'package:flutter/foundation.dart';
import '../model/social_work.dart';

class SocialWorkProvider with ChangeNotifier {
  final List<SocialWork> _socialWorks = [
    SocialWork(
        title: 'สอนเด็ก',
        hours: 5,
        date: DateTime.now(),
        category: 'การศึกษา'),
    SocialWork(
        title: 'ปลูกป่า',
        hours: 3,
        date: DateTime.now(),
        category: 'สิ่งแวดล้อม'),
    SocialWork(
        title: 'บริจาคเลือด',
        hours: 2.0,
        date: DateTime.now(),
        category: 'สุขภาพ'),
  ];

  List<SocialWork> get socialWorks => _socialWorks;

  void addSocialWork(SocialWork socialWork) {
    _socialWorks.add(socialWork);
    notifyListeners();
  }

  void removeSocialWork(int index) {
    _socialWorks.removeAt(index);
    notifyListeners();
  }
}