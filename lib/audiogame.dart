import 'package:audioplayers/audioplayers.dart';

class AudioGame {
  static final AudioGame _instance = AudioGame._internal();
  final AudioPlayer _player = AudioPlayer();

  factory AudioGame() {
    return _instance;
  }

  AudioGame._internal();

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
}
