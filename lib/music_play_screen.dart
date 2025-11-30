import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayScreen extends StatefulWidget {
  const MusicPlayScreen({super.key});

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playList = [
    Song(
      songName: 'Hellow',
      artistName: 'Santa Maria',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-3s.mp3',
      durationSecond: 3,
    ),
    Song(
      songName: 'Hellow 2',
      artistName: 'Santa Maria 2',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-6s.mp3',
      durationSecond: 6,
    ),
    Song(
      songName: 'Ola',
      artistName: 'Helena Amanda',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-9s.mp3',
      durationSecond: 9,
    ),
    Song(
      songName: 'Ola 2',
      artistName: 'Helena Amanda 2',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-12s.mp3',
      durationSecond: 12,
    ),
    Song(
      songName: 'Ola 3',
      artistName: 'Helena Amanda 3',
      songUrl: 'https://samplelib.com/lib/preview/mp3/sample-19s.mp3',
      durationSecond: 19,
    ),
  ];
  int _currentIndex = 0;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    _listenToPlayer();
    super.initState();
  }

  void _listenToPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onPlayerComplete.listen((_) => _next());
  }

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

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    final Song song = _playList[_currentIndex];
    final double maxSecond = max(_duration.inSeconds.toDouble(), 1);
    final double currentSecond = _position.inSeconds.toDouble().clamp(
      0,
      maxSecond,
    );
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
                Text(song.songName),
                Text(song.artistName),
                Slider(value: 0, onChanged: (value) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)),
                    Text(_formatDuration(_duration)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _previous,
                      icon: Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: _togglePlayer,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _playList.length,
              itemBuilder: (context, index) {
                final Song song = _playList[index];
                return ListTile(
                  title: Text(song.songName),
                  subtitle: Text(song.artistName),
                  trailing: Icon(Icons.skip_next),
                  // leading: Text("${_playList[index]}"),
                  onTap: () => _playSong(index),
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
