import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:record/record.dart';

import '../../constants/colors.dart';
import '../../utils/size_config.dart';

typedef RecordCallback = void Function(String);

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.recordingFinishedCallback,
  }) : super(key: key);

  final RecordCallback recordingFinishedCallback;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool _isRecording = false;
  final _audioRecorder = Record();

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        //Directory path = await getTemporaryDirectory();
        ////print(path.path);
        ////print('!!!');
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
        });
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();

    widget.recordingFinishedCallback(path!);

    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final Color? color;
    if (_isRecording) {
      icon = Icons.stop;
      color = Colors.white;
    } else {
      color = Colors.white;
      icon = FeatherIcons.mic;
    }
    return GestureDetector(
      onTap: () {
        _isRecording ? _stop() : _start();
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 12,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 1,
            top: SizeConfig.heightMultiplier * 0.5,
            bottom: SizeConfig.heightMultiplier * 0.5),
        decoration:
            const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
