// FloatingPlayer.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:signum_music/playerWidgets/BottomSheetPlayer.dart';
import '../controller/PlaySongController.dart';
import '../utils/AppColor.dart';
import '../utils/UniVar.dart';

class FloatingPlayer extends StatelessWidget {
  FloatingPlayer({super.key});

  var controller = Get.put(PlaySongController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      height: 50,
      width: 370,
      child: ElevatedButton(
        onPressed: (()=>BottomSheetPlayer.showBottomSheet(context,UniVar.data?.cast<SongModel>())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child:QueryArtworkWidget(
                id: controller.playingSong.value != null?controller.playingSong.value!.id:0,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: CircleAvatar(
                  radius: 20,
                  backgroundImage: controller.playingSong.value?.composer!=null? NetworkImage(controller.playingSong.value!.composer!):null,
                ),
              )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.playingSong.value != null
                        ? controller.playingSong.value!.displayNameWOExt
                        : "SongName",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    controller.playingSong.value != null
                        ? "${controller.playingSong.value!.artist}"
                        : "SongName",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.playIndex.value >0) {
                      controller.playSong(
                        UniVar.data![controller.playIndex.value-1],
                        controller.playIndex.value-1,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'No next song available',
                        backgroundColor: Colors.grey,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    size: 40,
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  child: Transform.scale(
                    scale: 1.5,
                    child: IconButton(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.audioPlayer.pause();
                            controller.isPlaying(false);
                          } else {
                            controller.audioPlayer.play();
                            controller.isPlaying(true);
                          }
                        },
                        icon: controller.isPlaying.value
                            ? Icon(Icons.pause)
                            : Icon(
                          Icons.play_arrow_rounded,
                        )),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.playIndex.value < UniVar.data!.length - 1) {
                      controller.playSong(
                        UniVar.data![controller.playIndex.value+1],
                        controller.playIndex.value + 1,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'No next song available',
                        backgroundColor: Colors.grey,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.skip_next_rounded,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
