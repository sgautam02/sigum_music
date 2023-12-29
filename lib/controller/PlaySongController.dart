// PlaySongController.dart
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signum_music/utils/UniVar.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlaySongController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var playingSong = Rx<SongModel?>(null);

  @override
  Future<void> onInit() async {
    var permissions = checkPermission();
    if(await permissions){

      audioPlayer.playerStateStream.listen((playerState) {
        isPlaying.value=playerState.playing;
        if (playerState.processingState == ProcessingState.completed) {

          playNextSong();
        }
      });
    }else {
      checkPermission();
    }
    super.onInit();
  }

  playSong(SongModel? song, index) {
    playIndex.value = index;
    try {
      // Update playingSong using .value
      playingSong.value = song;
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song!.uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e);
    }
  }
  playSongs(String uri,index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e);
    }
  }


  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationToSecond(second) {
    var duration = Duration(seconds: second);
    audioPlayer.seek(duration);
  }

  Future<bool> checkPermission() async {
    var audio = await Permission.audio.request();
    var photo = await Permission.photos.request();
    if (audio.isGranted && photo.isGranted) {
      return true;
    } else {

     checkPermission();
    }
    return false;
  }

  playNextSong() {
    // Check if there's a next song to play
    if (playIndex.value < UniVar.data!.length - 1) {
      var nextIndex = playIndex.value + 1;
      var nextSong = UniVar.data?[nextIndex];
      playSong(nextSong, nextIndex);
    } else {
      // If it's the last song, stop playback or handle as needed
      audioPlayer.stop();
      isPlaying(false);
    }
  }
}
