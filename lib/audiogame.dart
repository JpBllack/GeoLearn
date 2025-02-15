import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioGame extends WidgetsBindingObserver {
  static final AudioGame _instance = AudioGame._internal();
  final AudioPlayer _player = AudioPlayer();
  bool _isMusicPlaying = false; // Flag para garantir que a música não toque mais de uma vez.

  factory AudioGame() {
    return _instance;
  }

  AudioGame._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> playMusic() async {
    if (!_isMusicPlaying) {  // Verifica se a música não está tocando.
      await _player.setReleaseMode(ReleaseMode.loop);  // Música em loop.
      await _player.play(AssetSource('songs/musica.mp3')); // Caminho do arquivo.
      _isMusicPlaying = true;  // Marca que a música está tocando.
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _isMusicPlaying = false;  // Reseta a flag quando a música for parada.
  }

  Future<void> pauseMusic() async {
    await _player.pause();
  }

  Future<void> resumeMusic() async {
    await _player.resume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.pause();
    } else if (state == AppLifecycleState.resumed && !_isMusicPlaying) {
      playMusic();  // Se a música não estiver tocando, retome a música.
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
  }
}
