import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signum_music/utils/AppColor.dart';

import '../topicWiseSong/AlbumPage.dart';
import '../topicWiseSong/ArtistPage.dart';
import '../topicWiseSong/SongsPage.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin{
  late final TabController _tabController;
   List<String> topic=[
     "Recent",
     "Daily mix",
     "Favourites",
     "Playlists",
   ];

   List<Icon> topicIcon=[
     Icon(CupertinoIcons.clock,color: Colors.white,),
     Icon(Icons.calendar_today,color: Colors.white,),
     Icon(CupertinoIcons.heart,color: Colors.white,),
     Icon(CupertinoIcons.music_albums,color: Colors.white,),
   ];

   List<List<Color>> tileColor =[
     [Colors.blue,Colors.blue.shade100],
     [Colors.purple,Colors.purple.shade100],
     [Colors.teal,Colors.teal.shade100],
     [Colors.green,Colors.green.shade100],
   ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 150,
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: tileColor[index],
                    ),
                  ),
                  margin: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      topicIcon[index],
                      Text(topic[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          // Expanded to take remaining vertical space
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  // title: Container(
                  //   width: double.maxFinite,
                  //   color: AppColor.mainColor,
                  //   height: 100,
                  //   child: Text("ads"),
                  // ),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: [
                      Text("Songs"),
                      Text("Artist"),
                      Text("Albums"),
                      Text("Folder"),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    SongsPage(),
                    ArtistPage(),
                    AlbumPage(),
                    Container(height: 400,child: Center(child: Text("Sons here"),),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
