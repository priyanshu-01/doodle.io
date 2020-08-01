import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioPlayer {
  Soundpool pool;
  Map<
      String,
      // Future<int>
      int> soundTracks;
  AudioPlayer() {
    pool = Soundpool(streamType: StreamType.music);
    // int notification = ;
    // initialiseSounds();
  }
  Future<void> initialiseSounds() async {
    soundTracks = {
      'click': await createSounds('assets/sounds/button_click.mp3'),
      'reaction': await createSounds('assets/sounds/reaction.mp3'),
      'colorChange': await createSounds('assets/sounds/colorChange.mp3'),
      'someoneGuessed': await createSounds('assets/sounds/someoneGuessed.mp3'),
    };
  }

  Future<int> createSounds(String path) async {
    var asset = await rootBundle.load(path);
    return await pool.load(asset);
  }

  Future<void> playSound(String soundType) async {
    int soundId = soundTracks[soundType];
    // var sound = await soundId;
    // int streamId =
    await pool.play(soundId);
  }
}
