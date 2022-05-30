import 'package:app/music.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'page_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundify App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
    _pageManager = PageManager();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  List<Music> myMusicList = [
    Music(
      'Haine & Sex',
      'Gazo',
      'assets/gazo.jpg',
      'https://www.youtube.com/watch?v=pzpp4EehoPA&ab_channel=GAZOOFFICIEL',
    ),
    Music(
      'Bailando',
      'Carlos Vives',
      'assets/images/bailando.jpg',
      'https://www.youtube.com/watch?v=pzpp4EehoPA&ab_channel=GAZOOFFICIEL',
    ),
    Music(
      'Bailando',
      'Carlos Vives',
      'assets/images/bailando.jpg',
      'https://www.youtube.com/watch?v=pzpp4EehoPA&ab_channel=GAZOOFFICIEL',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //center the appbar
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      //print the data of the first music in a square
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '${myMusicList[0].title}',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              '${myMusicList[0].singer}',
              style: Theme.of(context).textTheme.headline5,
            ),
            Image.asset(
              '${myMusicList[0].imagePath}',
              width: 200,
              height: 200,
            ),
            const Spacer(),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: _pageManager.seek,
                );
              },
            ),
          ],
        ),
      ),
      //precedent, play and next button
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: () {},
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}