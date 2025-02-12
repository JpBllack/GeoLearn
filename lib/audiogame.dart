import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioGame extends WidgetsBindingObserver {
  static final AudioGame _instance = AudioGame._internal();
  final AudioPlayer _player = AudioPlayer();
  bool _wasPlaying = false;

  factory AudioGame() {
    return _instance;
  }

  AudioGame._internal()
  {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> playMusic() async {
    await _player.setReleaseMode(ReleaseMode.loop); // Música em loop
    await _player.play(AssetSource('songs/musica.mp3')); // Caminho do arquivo
  }

  Future<void> stopMusic() async {
    await _player.stop();
  }

  Future<void> pauseMusic() async {
    await _player.pause();
  }

  Future<void> resumeMusic() async {
    await _player.resume();
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) 
  {
    if (state == AppLifecycleState.paused) 
    {
      _player.pause();
      _wasPlaying = true;
    } else if (state == AppLifecycleState.resumed && _wasPlaying) 
    {
      _player.resume();
      _wasPlaying = false;
    }
  }

  void dispose()
  {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
  }

}
