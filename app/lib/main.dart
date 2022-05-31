import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'page_manager.dart';
import 'package:app/utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundify App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Soundify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(myMusicList[0].urlSong);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  int position = 0;
  int get listSize => myMusicList.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(204, 60, 60, 60),
      appBar: appBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            space(40),
            songPicture(myMusicList[position].imagePath),
            space(50),
            progressBar(_pageManager),
            space(50),
            songTitle(myMusicList[position].title),
            space(10),
            songArtist(myMusicList[position].singer),
            space(70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      position = (position - 1) % listSize;
                      _pageManager.changeSong(myMusicList[position].urlSong);
                    });
                  },
                ),
                ValueListenableBuilder<ButtonState>(
                  valueListenable: _pageManager.buttonNotifier,
                  builder: (_, value, __) {
                    switch (value) {
                      case ButtonState.loading:
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 40.0,
                          height: 40.0,
                          color: Colors.white,
                          child: const CircularProgressIndicator(),
                        );
                      case ButtonState.paused:
                        return IconButton(
                          icon: const Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 40.0,
                          onPressed: _pageManager.play,
                        );
                      case ButtonState.playing:
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          color: Colors.white,
                          iconSize: 40.0,
                          onPressed: _pageManager.pause,
                        );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      position = (position + 1) % listSize;
                      _pageManager.changeSong(myMusicList[position].urlSong);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
