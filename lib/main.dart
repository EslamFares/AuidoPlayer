import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "00:00";
  String completTime = "00:00";
  @override
  void initState() {
    super.initState();
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().substring(0, 7);
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completTime = duration.toString().substring(0, 7);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/micro.jpg',
            fit: BoxFit.contain,
          ),
          Container(
            width: width * .6,
            height: 70,
            margin: EdgeInsets.only(
              top: height * 0.7,
              left: width * .2,
              right: width * .2,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(currentTime),
                    Text(' / '),
                    Text(completTime),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                        icon: isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 40,
                                color: Colors.redAccent,
                              )
                            : Icon(Icons.play_arrow,
                                size: 40, color: Colors.greenAccent),
                        onPressed: () {
                          if (isPlaying) {
                            _audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            _audioPlayer.resume();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        }),
                    SizedBox(width: 30),
                    IconButton(
                        icon: Icon(
                          Icons.stop,
                          size: 30,
                        ),
                        onPressed: () {
                          _audioPlayer.stop();
                          setState(() {
                            isPlaying = false;
                          });
                        }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.audiotrack),
        onPressed: () async {
          // String filePath ="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

          String filePath = await FilePicker.getFilePath(type: FileType.audio);

          int status = await _audioPlayer.play(filePath, isLocal: false);

          if (status == 1) {
            setState(() {
              isPlaying = true;
            });
          }
        },
      ),
    );
  }
}
