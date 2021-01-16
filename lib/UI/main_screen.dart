import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../model/AudioPlayerModel.dart';


class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mini Audio Player")),
      body: Center(
        child: StreamBuilder<PlaybackState>(
          stream: AudioService.playbackStateStream,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            final processingState = snapshot.data?.processingState
                ?? AudioProcessingState.stopped;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (playing)
                  RaisedButton(child: Text("Pause"), onPressed: pause)
                else
                  RaisedButton(child: Text("Play"), onPressed: play),
                if (processingState != AudioProcessingState.stopped)
                  RaisedButton(child: Text("Stop"), onPressed: stop),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.skip_previous_rounded), onPressed: skipToPrev),
                    IconButton(icon: Icon(Icons.skip_next_rounded), onPressed: skipToNext),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// This initiation of the entrypoint and test URL are obviously not the
// best practice, but for the sake of dev time
List<String> urls =  [
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"];

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerModel(urls));
}


Future<void> play() async {
  if (AudioService.running) {
    await AudioService.play();
  } else {
    await AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
    // print('starting...');
  }
}

Future<void> pause() async => await AudioService.pause();

Future<void> stop() async => await AudioService.stop();


//Both of the next functions do nothing when end/beginning of queue is reached
Future<void> skipToNext() async {
  await AudioService.skipToNext();
}

Future<void> skipToPrev() async {
  await AudioService.skipToPrevious();
}

