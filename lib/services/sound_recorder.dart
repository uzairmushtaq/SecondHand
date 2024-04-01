import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
class SoundRecorder{
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialize=true;
  bool get isRecording =>_audioRecorder!.isRecording;
  Future init()async{
    _audioRecorder =  FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status !=PermissionStatus.granted){
      throw RecordingPermissionException("Microphone Permission");
    }
   await _audioRecorder!.openAudioSession();
   _isRecorderInitialize=true;
  }
  void dispose(){
    _audioRecorder!.closeAudioSession();
    _audioRecorder=null;
    _isRecorderInitialize=false;

  }
  Future _record()async{
    if(!_isRecorderInitialize) return;
    await _audioRecorder!.startRecorder(toFile:"audio_example.aac");
  }
  Future _stop()async{
     if(!_isRecorderInitialize) return;
    await _audioRecorder!.stopRecorder();
  }
  Future toggleRecorder() async{
    if(_audioRecorder!.isStopped){
      _record();
    }else{
      _stop();
    }
  }
}