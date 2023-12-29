import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/PlaySongController.dart';
import '../utils/AppColor.dart';
import '../utils/UniVar.dart';

class BottomSheetPlayer {
  static void showBottomSheet(BuildContext context, List<SongModel>? data) {
    var controller = Get.put(PlaySongController());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.keyboard_arrow_down)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.more_vert))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 400,
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                    ),
                    child: QueryArtworkWidget(
                      id: controller.playingSong.value != null
                          ? controller.playingSong.value!.id
                          : 0,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: CircleAvatar(
                        radius: 150,
                        backgroundImage:
                            controller.playingSong.value?.composer != null
                                ? NetworkImage(
                                    controller.playingSong.value!.composer!)
                                : null,
                      ),
                      artworkBorder: BorderRadius.circular(10),
                      quality: 100,
                    ),
                  ),
                  Text(
                      controller.playingSong.value != null
                          ? controller.playingSong.value!.displayNameWOExt
                          : "SongName",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(
                      controller.playingSong.value != null
                          ? "${controller.playingSong.value!.artist}"
                          : "artist",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Icon(CupertinoIcons.heart)],
                  ).paddingOnly(right: 20),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.position.value),
                        Expanded(
                            child: Slider(
                                thumbColor: AppColor.mainColor,
                                // activeColor: AppColor.sliderColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller
                                      .changeDurationToSecond(newValue.toInt());
                                  newValue = newValue;
                                })),
                        Text(controller.duration.value)
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Handle shuffle
                          },
                          icon: Icon(CupertinoIcons.shuffle),
                        ),
                        IconButton(
                          onPressed: () {
                            print(
                                "Current playIndex========================================================================: ${controller.playIndex.value}");
                            if (controller.playIndex.value > 0) {
                              controller.playSong(
                                data![controller.playIndex.value - 1],
                                controller.playIndex.value - 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'No previous song available',
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
                          backgroundColor: AppColor.mainColor,
                          radius: 25,
                          child: Transform.scale(
                            scale: 1.8,
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
                                    ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.playIndex.value < data!.length - 1) {
                              controller.playSong(
                                data![controller.playIndex.value + 1],
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
                        IconButton(
                          onPressed: () {
                            // Handle speaker icon
                          },
                          icon: Icon(CupertinoIcons.speaker_slash_fill),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            NextSongList(data)
          ],
        );
      },
    );
  }
}

class NextSongList extends StatelessWidget {
  final List<SongModel>? data;

  NextSongList(this.data, {super.key});

  final GlobalKey _sheet = GlobalKey();
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  var playerController = Get.put(PlaySongController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.04,
      maxChildSize: 1,
      minChildSize: 0.04,
      snap: true,
      snapSizes: const [0.5],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.grey,
                offset:Offset (0,-2)
              )
            ]
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Text("Next Up",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: data![index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: CircleAvatar(
                          radius: 32,
                          backgroundImage:
                          data?[index].composer != null
                              ? NetworkImage(data![index].composer!)
                              : null,
                        ),
                      ),
                      title: Text(data![index].displayNameWOExt),
                      subtitle: Text(data![index].data),
                      onTap: () {
                        playerController.playSong(data![index], index);
                        UniVar.data = data!;
                        // BottomSheetPlayer.showBottomSheet(context,UniVar.data);
                      },
                    );
                  },
                  childCount: data?.length ?? 0,
                ),
              ),
            ],
          )

        );
      },
    );
  }
}
