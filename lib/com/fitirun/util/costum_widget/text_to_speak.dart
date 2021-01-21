import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class TextToSpeak {


  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  dynamic languages;
  String _newVoiceText  =  "ISTO É UM TESTE";
  FlutterTts flutterTts = FlutterTts();

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  TextToSpeak() {
    print("CALLED");
    initSettings();
    var s = _getLanguages();
    print(s);
    _speak();
  }


  void initSettings() {
    flutterTts = FlutterTts();
    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {

    });

    flutterTts.setCompletionHandler(() {

    });

    flutterTts.setCancelHandler(() {

    });
  }


  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print(languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines.then((value) {
        print(value);
        if (value != null) {
          for (dynamic engine in value) {
            print(engine);
          }
        }
    }
    );

  }


  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
        print('TESTE');
      }
    }
  }
}