import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:signum_music/controller/PlaySongController.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../querys/search.dart';
import '../querys/youtubeService.dart';
import '../utils/UniVar.dart';


class PlayListData extends StatelessWidget {
  final SearchPlaylist playlist;
  PlayListData({super.key, required this.playlist});


  Future<List<SongModel>> getDataFromPlaylist(PlaylistId id) async {
    List<Video> songs = await SearchQueries.songsFromPlaylist(id);
    Future<List<SongModel>> newMusicList =  YoutubeService.addSongInQueue(songs);
    return newMusicList;
  }

  getSongs() async {

  }

  @override
  Widget build(BuildContext context) {
    var playController= Get.put(PlaySongController());
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        children: [
          Container(
            child: Row(
              children: [
                Image(image: NetworkImage(playlist.thumbnails.first.url.toString())),
                SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.title,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Add additional UI elements here if needed
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getDataFromPlaylist(playlist.id),
              builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
            
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data;
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (cntx,index){
                          return ListTile(
                              title: Text(data[index].title.substring(0,20)),
                              subtitle: Text("${data![index].data}"),
                            onTap:((){
                              playController.playSongs(data[index].uri!, index);
                              UniVar.data=data;
                            }),
                          );
                        }
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            
            
            ),
          ),
        ],
      )
    );
  }
}
