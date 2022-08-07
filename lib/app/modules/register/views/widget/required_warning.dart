import 'package:flutter/material.dart';

class RequiredWarning extends StatelessWidget {
  const RequiredWarning({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Text(
        "Wajib diisi",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
