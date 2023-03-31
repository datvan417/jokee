import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Divider(
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text(
            'This app is created as part of Hlsoluotions program. The materials contained on this website are provided for general information only and do not constitute any form of advice. HLS assumes no responsibility for the accuracy of any particular statement and accepts no liability for any loss or damage which may arise from reliance on the information contained on this site.',
            style: TextStyle(
                color: Color.fromARGB(255, 125, 124, 124), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          'Copyright 2021 HLS',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
