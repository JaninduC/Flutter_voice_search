import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart ' as stt;
import 'package:speech_to_text/speech_to_text.dart%20';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const VoiceSearchTest(),
    );
  }
}

class VoiceSearchTest extends StatefulWidget {
  const VoiceSearchTest({Key? key}) : super(key: key);

  @override
  State<VoiceSearchTest> createState() => _VoiceSearchTestState();
}

class _VoiceSearchTestState extends State<VoiceSearchTest> {
  bool _isListensing = false;
  late stt.SpeechToText _speech;
  SpeechToText speech = SpeechToText();
String text="Press Mic Icon and speak to write";
  @override
  void initState() {
    _speech=stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Voice Search Test",
      )),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        glowColor: Colors.red,
        animate: _isListensing,
        showTwoGlows: true,
        child: FloatingActionButton(
          onPressed: () {
            onListing();
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: SingleChildScrollView(
            child: Text(text),
          ),
        ),
      ),
    );
  }
  void onListing()async{
    Future.delayed(Duration(milliseconds: 2500), () {
     setState(() {
       print("test");
       speech.stop();
       _isListensing=false;
     });
    });
    print("click");
    var avilable= await speech.initialize(

    );
    if(avilable){
      setState(() {

        if(!_isListensing){
          _isListensing=true;
          speech.listen(
            listenMode: ListenMode.search,
              onResult: (result){
                setState(() {

                  text = result.recognizedWords;
                });

              }
          );
        }else{
          _isListensing=false;
          speech.stop();
        }
      });
    }else{
       speech.stop();
    }

  }
  void errorListener(SpeechRecognitionError error) {
    print(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      text = '${error.errorMsg} - ${error.permanent}';
    });
  }
}
