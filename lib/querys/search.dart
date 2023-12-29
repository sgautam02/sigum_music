import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchQueries{

  static var yt =YoutubeExplode();
  static Future<List<Video>> fetchSongsList(String searchQuery) async {
    List<Video> searchResults =[];
    try {
      searchResults = await yt.search.search(searchQuery,filter: TypeFilters.video);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error in fetchSongsList: $e');
    }
    return searchResults;
  }

  static Future<List<SearchPlaylist>> fetchPlayList(String query) async {
    List<SearchPlaylist> searchResults = [];
    try {
      SearchList searchResultsRaw = await yt.search.searchContent(query,filter: TypeFilters.playlist);
      searchResults = searchResultsRaw.whereType<SearchPlaylist>().toList();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error in fetchSongsPlayList: $e');
    }
    return searchResults;
  }





  static Future<List<Video>> songsFromPlaylist(PlaylistId id) async {
    List<Video> playListSongs = [];

    try {
      Stream<Video> songs = yt.playlists.getVideos(id);
      var playlist= yt.playlists.get(id);

      await for (var song in songs) {
        playListSongs.add(song);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error in fetching songs from playlist: $e');
    }

    return playListSongs;
  }



}

