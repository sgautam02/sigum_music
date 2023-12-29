import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../controller/PlaySongController.dart';
import '../utils/UniVar.dart';

class YoutubeService{


  static Future<List<SongModel>> addSongInQueue(List<Video> videos)async {
    var yt = YoutubeExplode();
    List<SongModel> updatedList = [];
    for (var video in videos) {
      try {
        var audioStreams = await yt.videos.streamsClient.getManifest(video.id.value);
        if (audioStreams.audioOnly.isNotEmpty) {
          var audioStream = audioStreams.audioOnly.last;
          String thumbnail = video.thumbnails.highResUrl;
          // Extract additional information if available
          final List<String> titleParts = video.title.split('-');
          final String songName = titleParts.length > 1 ? titleParts[1].trim() : video.title.trim();
          final String artistName = titleParts.length > 0 ? titleParts[0].trim() : '';

          SongModel songModel = SongModel({
            "_id": video.id.value.hashCode, // Use video ID for a unique identifier
            "_data": formatDuration(video.duration!),
            "_uri": audioStream.url.toString(), // You may adjust this based on your needs
            "_display_name": songName,
            "_display_name_wo_ext": songName,
            "_size": 0, // You may need to obtain the actual size from the API
            "album": null, // Add logic to get album information if available
            "album_id": null, // You may need to obtain the actual album ID from the API
            "artist": artistName,
            "artist_id": null, // You may need to obtain the actual artist ID from the API
            "genre": null, // Add logic to get genre information if available
            "genre_id": null, // You may need to obtain the actual genre ID from the API
            "bookmark": null, // You may need to obtain the actual bookmark information from the API
            "composer": video.thumbnails.highResUrl, // You may need to obtain the actual composer information from the API
            "date_added": null, // You may need to obtain the actual date added from the API
            "date_modified": null, // You may need to obtain the actual date modified from the API
            "duration": null, // You may need to obtain the actual duration from the API
            "title": songName,
            "track": null, // You may need to obtain the actual track information from the API
            "file_extension": null, // You may need to obtain the actual file extension from the API
            "is_alarm": null, // You may need to obtain the actual is_alarm information from the API
            "is_audiobook": null, // You may need to obtain the actual is_audiobook information from the API
            "is_music": true, // Assuming all items in musicList are music
            "is_notification": null, // You may need to obtain the actual is_notification information from the API
            "is_podcast": null, // You may need to obtain the actual is_podcast information from the API
            "is_ringtone": null, // You may need to obtain the actual is_ringtone information from the API
          });
          updatedList.add(songModel);
        }
      }catch (e) {
        print(e);
      }

    }
    yt.close();
    return updatedList;// Refresh the UI after adding songs to the list
  }
  static String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    return '$minutesStr:$secondsStr';
  }
  static playSong(int index,List<Video> videos) async {print("taped");
    var playController= PlaySongController();

    UniVar.data=  await addSongInQueue(videos);

    playController.playSongs(UniVar.data![index].uri!, index);
  }


}