import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayScreen extends StatefulWidget {
  const MusicPlayScreen({super.key});

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playList = [];
  int _currentIndex = 0;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Future<void> _playSong(int index) async {
    _currentIndex = index;
    final song = _playList[index];
    setState(() {
      _position = Duration.zero;
      _duration = Duration(seconds: song.durationSecond);
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(
      UrlSource(_playList[index].songUrl),
    ); //parseUrl hoto jodi API theke call kore nite hoto, tokhn parse kore nite hoto API theke
  }

  Future<void> _next() async {
    final int next = (_currentIndex + 1) % _playList.length;
    await _playSong(next);
  }

  Future<void> _previous() async {
    final int previous =
        (_currentIndex - 1 + _playList.length) % _playList.length;
    await _playSong(previous);
  }

  Future<void> _togglePlayer() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Card(
            child: Column(
              children: [
                Text("Song Name"),
                Text("Artist Name"),
                Slider(value: 0, onChanged: (value) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Current time"), Text("total duration")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.skip_previous),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Song title"),
                  subtitle: Text("Artist Name"),
                  trailing: Icon(Icons.skip_next),
                  leading: Text("Number"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Song {
  final String songName;
  final String artistName;
  final String songUrl;
  final int durationSecond;

  const Song({
    required this.songName,
    required this.artistName,
    required this.songUrl,
    required this.durationSecond,
  });
}
