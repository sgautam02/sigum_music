import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/PlaySongController.dart';
import '../playerWidgets/BottomSheetPlayer.dart';
import '../utils/UniVar.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

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
            child: FutureBuilder<List<ArtistModel>>(
              future: controller.audioQuery.queryArtists(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL,
              )
                ,
              builder: (BuildContext context, AsyncSnapshot<List<ArtistModel>> snapshot) {
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
                            type: ArtworkType.ARTIST,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 32,
                            ),
                          ),
                          title: Text(snapshot.data![index].artist),
                          subtitle: Text("${snapshot.data![index].numberOfTracks!}"),
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
