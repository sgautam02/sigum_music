import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:signum_music/pages/PlayListData.dart';
import 'package:signum_music/querys/youtubeService.dart';
import 'package:signum_music/utils/UniVar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../controller/PlaySongController.dart';
import '../querys/search.dart';

class SearchMusic extends StatefulWidget {
  SearchMusic({Key? key}) : super(key: key);

  @override
  _SearchMusicState createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> with TickerProviderStateMixin{
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late TabController _tabController;
  // late SearchQueries searchQuery;

  var controller = Get.put(PlaySongController());
  var yt = YoutubeExplode();
  List<SongModel> musicList = [];
  bool isLoading = false;
  int visibleTilesCount = 3;
  bool showAllTiles = false;
  List<SearchPlaylist> playlists=[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    scrollController.addListener(_scrollListener);
  }

  Future<void> fetchAndAddSongs(String searchQuery) async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting the fetch
      });
      List<Video> songs = await SearchQueries.fetchSongsList(searchQuery);
      var playlist =await SearchQueries.fetchPlayList(searchQuery);
      List<SongModel> newMusicList = await YoutubeService.addSongInQueue(songs);

      setState(() {
        playlists=playlist;
        musicList = newMusicList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      Fluttertoast.showToast(msg: 'Error in fetchSongsList: $e');
    }
  }


  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            onSubmitted:(value)=> fetchAndAddSongs(value),
            decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none
                ),
                hintText: "Type something here",
                prefixIcon: Icon(Icons.search)
            ),
            textInputAction: TextInputAction.search
          ),
        ).paddingAll(5),
        SizedBox(
          child:TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Sings",),
              Tab(text: "Playlists",),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
              children: [
                Container(
                  child: isLoading ? const Center(
                    child: CircularProgressIndicator(),
                  ): ListView.builder(
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      final song = musicList[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 5,),
                        child: ListTile(
                          onTap:(() {
                            controller.playSong(song,index);
                            UniVar.data =musicList;
                          }),
                          leading:  CircleAvatar(
                            radius: 35,
                            backgroundImage: song.composer!=null? NetworkImage(song.composer!):null,
                          ),
                          title: Text(song.title!, overflow: TextOverflow.ellipsis),
                          subtitle: Text(song.data),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: isLoading ? const Center(
                    child: CircularProgressIndicator(),
                  ): ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return GestureDetector(
                        onTap: ((){
                          Get.to(PlayListData(playlist:playlist));
                        }),
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          playlist.thumbnails.first?.url.toString() ?? 'https://www.theaudiostore.in/cdn/shop/articles/Creating_the_Perfect_Playlist-_Tips_and_Tricks_for_Audiophiles.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Text(playlist.videoCount.toString()),
                                      )
                                  )
                                ],
                              ),
                              SizedBox(width: 10), // Add spacing between image and text
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
                      );
                    },
                  )


                ),
              ]
          ),
        )

      ],
    );

  }

  void _scrollListener(){
    print("scroll controller called");
  }
}


