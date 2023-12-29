import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/PlaySongController.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlaySongController());
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.white,
            child: const ListTile(
              title: Text("Shuffle playback"),
              leading: Icon(Icons.play_circle),
              trailing: Icon(Icons.shuffle),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AlbumModel>>(
              future: controller.audioQuery.queryAlbums(
                ignoreCase: true,
                orderType: OrderType.DESC_OR_GREATER,
                sortType: null,
                uriType: UriType.EXTERNAL,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<AlbumModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or another loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('No data available'); // Handle the case where data is null
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.ALBUM,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 32,
                            ),
                          ),
                          title: Text(snapshot.data![index].album,overflow: TextOverflow.fade,),
                          subtitle: Text("${snapshot.data![index].numOfSongs!}"),
                          onTap: (){
                            // controller.playSong(snapshot.data![index], index);
                            // UniVar.data =snapshot.data!;
                            // BottomSheetPlayer.showBottomSheet(context,UniVar.data);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          /*Visibility(
            visible: controller.isPlaying.value,
            child: ElevatedButton(
              onPressed: () {
                // Handle button press when playing is true
              },
              child: Container(),
            ),
          ),*/
        ],
      ),
    );
  }
}
