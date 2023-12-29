import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:signum_music/utils/UniVar.dart';

import '../controller/PlaySongController.dart';
import '../playerWidgets/BottomSheetPlayer.dart';

class SongsPage extends StatelessWidget {
   SongsPage({Key? key}){
     var controller = PlaySongController();
     var status= controller.checkPermission();
   }

   getSong(PlaySongController controller) async {
     List<SongModel> songs= await controller.audioQuery.querySongs();

   }



  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlaySongController());
    getSong(controller);
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
            child: FutureBuilder<List<SongModel>>(
              future: controller.audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // or another loading indicator
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
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 32,
                            ),
                          ),
                          title: Text(snapshot.data![index].displayNameWOExt),
                          subtitle: Text(snapshot.data![index].artist!),
                          trailing: Wrap(
                            spacing: 8.0,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle the first IconButton press
                                },
                                icon: Icon(Icons.share),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle the second IconButton press
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                          onTap: (){
                            controller.playSong(snapshot.data![index], index);
                            UniVar.data =snapshot.data!;
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
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
