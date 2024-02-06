import 'package:flutter/material.dart';

extension BuildContextExtention on BuildContext {
  pushTo(Widget child) {
    Navigator.push(this, MaterialPageRoute(builder: (_) => child));
  }

  pushAndClear(Widget child) {
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => child));
  }

  pushAndClearAll(Widget child) {
    Navigator.pushAndRemoveUntil(
        this, MaterialPageRoute(builder: (_) => child), (_) => false);
  }

  back() {
    Navigator.pop(this);
  }
}
