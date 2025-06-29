import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioGame extends WidgetsBindingObserver {
  static final AudioGame _instance = AudioGame._internal();
  final AudioPlayer _player = AudioPlayer();
  bool _isMusicPlaying = false;

  factory AudioGame() {
    return _instance;
  }

  AudioGame._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> playMusic() async {
    // Para garantir restart limpo
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('songs/musica.mp3'));
    _isMusicPlaying = true;
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _isMusicPlaying = false;
  }

  Future<void> pauseMusic() async {
    await _player.pause();
    _isMusicPlaying = false;
  }

  Future<void> resumeMusic() async {
    if (!_isMusicPlaying) {
      await _player.resume();
      _isMusicPlaying = true;
    }
  }

  bool get isMusicPlaying => _isMusicPlaying;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pauseMusic();
    } else if (state == AppLifecycleState.resumed && _isMusicPlaying) {
      resumeMusic();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
  }
}
