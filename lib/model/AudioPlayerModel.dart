import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'media_library.dart';



class AudioPlayerModel extends BackgroundAudioTask {
  AudioPlayer _audioPlayer = AudioPlayer();
  MediaLibrary _mediaLibrary;
  List<String> audioURLs;


  AudioPlayerModel(this.audioURLs){
    // try {
    //   _audioPlayer.setUrl(audioURLs[0]);
    // } on Exception {
    //   print("Empty List of URLs");
    // } finally {
    //   audioURLs = ['https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'];
    // }

    _mediaLibrary = MediaLibrary(audioURLs);
  }

  List<MediaItem> get queue => _mediaLibrary.items;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // Broadcast that we're connecting, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.connecting);


    // Load and broadcast the queue
    AudioServiceBackground.setQueue(queue);
    try {
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children:
        queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      // In this example, we automatically start playing on start.
      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }

    // Now we're ready to play
    _audioPlayer.play();
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onStop() async {
    // Stop playing audio.
    _audioPlayer.stop();
    // Broadcast that we've stopped.
    await AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.stopped);
    // Shut down this background task
    await super.onStop();
  }

  @override
  // ignore: missing_return
  Future<void> onPlay() {
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
    // Start playing audio.
    _audioPlayer.play();
  }

  @override
  // ignore: missing_return
  Future<void> onPause() {
    // Broadcast that we're paused, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
        processingState: AudioProcessingState.ready);
    // Pause the audio.
    _audioPlayer.pause();

  }

  @override
  Future<void> onSkipToNext() async{
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.skippingToNext);

    await _audioPlayer.seekToNext();
    print('next');
  }

  @override
  Future<void> onSkipToPrevious() async {
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.skippingToPrevious);

    await _audioPlayer.seekToPrevious();
  }
}