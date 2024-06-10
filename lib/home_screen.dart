import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainView(),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainView createState() => _MainView();
}

class _MainView extends State<MainView> {
  late stt.SpeechToText speechToText;
  final FlutterTts tts = FlutterTts();
  bool isListening = false;
  bool iconVisibility = false;

  TextEditingController textValue = TextEditingController(); //내용 입력 컨트롤러
  String labelText1 = "SST 활성화";
  String labelText2 = "TTS 음성재생";

  void initState() {
    super.initState();
    textValue.clear();
    labelText1 = "SST 활성화";
    labelText2 = "TTS 음성재생";
    tts.setLanguage("en-US");
    tts.setSpeechRate(0.5);
    tts.setVolume(100);
    speechToText = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() {
          isListening = true;
          iconVisibility = true;
        });
        speechToText.listen(
          onResult: (SpeechRecognitionResult result) {
            setState(() {
              textValue.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => isListening = false);
      iconVisibility = false;
      speechToText.stop();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text('동적 음성 서비스'),
          ),
          backgroundColor: Colors.amberAccent),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 30),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: Column(children: [
                Container(

                  child: Expanded(
                      child: Scrollbar(
                          // child : TextField(
                          //   controller: textValue,
                          //
                          //
                          //   decoration: InputDecoration(
                          //     // labelText: '텍스트 입력',
                          //     hintText: '텍스트를 입력해주세요',
                          //     border: OutlineInputBorder(), //외곽선
                          //   ),
                          // ),
                          child: TextField(
                    controller: textValue,
                    showCursor: true,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.pink[100],
                        hintText: "*Text Input Field",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )
                        // contentPadding: EdgeInsets.symmetric(vertical: 120),
                        ),
                  ))),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.greenAccent, // background
                    //   onPrimary: Colors.black, // foreground
                    // ),
                    onPressed: () {
                      _listen();
                    },
                    child: Text('${labelText1}'),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.greenAccent, // background
                    //   onPrimary: Colors.black, // foreground
                    // ),
                    onPressed: () {
                      tts.speak(textValue.text);
                    },
                    child: Text('${labelText2}'),
                  ),
                ),
                SizedBox(height: 30),

                Expanded(
                  child: Visibility(
                    child: Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    visible: iconVisibility,
                  ),
                )
              ]))
        ],
      )),
    );
  }
}
