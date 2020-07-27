import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioPlayer {
  Soundpool pool;
  Map<String, Future<int>> soundTracks;
  AudioPlayer() {
    pool = Soundpool(streamType: StreamType.music);
    // int notification = ;
    soundTracks = {
      'click': createSounds('assets/sounds/button_click.mp3'),
      'reaction': createSounds('assets/sounds/reaction.mp3'),
      'colorChange': createSounds('assets/sounds/colorChange.mp3'),
      'someoneGuessed': createSounds('assets/sounds/someoneGuessed.mp3'),
    };
  }

  Future<int> createSounds(String path) async {
    var asset = await rootBundle.load(path);
    return await pool.load(asset);
  }

  Future<void> playSound(String soundType) async {
    Future<int> soundId = soundTracks[soundType];
    var sound = await soundId;
    int streamId = await pool.play(sound);
  }
}
