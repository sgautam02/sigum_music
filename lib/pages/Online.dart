import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart'as http;

class Online extends StatefulWidget {
  Online({Key? key}) : super(key: key);

  @override
  State<Online> createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    loadSearchResults();
  }

  // Inside the loadSearchResults method
  Future<void> loadSearchResults() async {
    String query = 'arjit'; // Replace with your actual query
    try {
      Map songData = await getSong(query);

      // Check if the expected keys are present in the response
      if (songData != null &&
          songData['contents'] != null &&
          songData['contents']['sectionListRenderer'] != null &&
          songData['contents']['sectionListRenderer']['contents'] != null &&
          songData['contents']['sectionListRenderer']['contents'][0]['musicCarouselShelfRenderer'] != null &&
          songData['contents']['sectionListRenderer']['contents'][0]['musicCarouselShelfRenderer']['contents'] != null) {

        // Extract relevant information from the response
        searchResults =
            (songData['contents']['sectionListRenderer']['contents'][0]['musicCarouselShelfRenderer']['contents'] as List)
                .map<Map<String, dynamic>>(
                    (dynamic content) => content['musicResponsiveListItemRenderer'] as Map<String, dynamic>)
                .toList();

        // Update the UI with the search results
        setState(() {});
      } else {
        print('Response structure is not as expected');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Search Results'),
      ),
      body:ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        var result = searchResults[index];
        return ListTile(
          title: Text(result['flexColumns'][0]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text']),
          subtitle: Text(result['flexColumns'][1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text']),
          onTap: () {
            // Add any action you want to perform when the item is tapped
            print('Video ID: ${result['videoId']}');
          },
        );
      },
    ));}


  Future<Map> getSong(String query) async {
    final String ytmDomain = 'music.youtube.com';
    final String baseApiEndpoint = '/youtubei/v1/';
    final Map<String, String> ytmParams = {
      'alt': 'json',
      'key': 'AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30'
    };
    final String userAgent =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0';

    Map<String, dynamic> body = {
      'context': {
        'client': {
          'clientName': 'WEB_REMIX',
          'clientVersion': '1.20230301.01.00',
        },
        'user': {},
      },
      'query': query,
    };

    Map<String, String> headers = {
      'user-agent': userAgent,
      'accept': '*/*',
      'accept-encoding': 'gzip, deflate',
      'content-type': 'application/json',
      'content-encoding': 'gzip',
      'origin': 'https://$ytmDomain',
      'cookie': 'CONSENT=YES+1',
      'Accept-Language': 'en',
    };

    final Uri uri = Uri.https(ytmDomain, baseApiEndpoint + 'search', ytmParams);
    final response = await post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      // print('Response: ${response.body}');
      return json.decode(response.body) as Map;
    } else {
      throw Exception('Failed to load song');
    }
  }

}
