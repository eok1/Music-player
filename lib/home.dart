import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:music/responsive.dart';
import 'package:music/shadowbox.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  LoopMode _loopMode = LoopMode.none;

  bool _shuffled = false;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    setState(() {
      assetsAudioPlayer.loopMode.listen((loopMode) {
        _loopMode = loopMode;
      });
    });

    openPlayer();
  }

  void _togglelooping() {
    assetsAudioPlayer.toggleLoop();
  }

  void _toggleshuffle() {
    setState(() {
      assetsAudioPlayer.loopMode.listen((loopMode) {
        _shuffled = !_shuffled;
      });
    });
    assetsAudioPlayer.shuffle = _shuffled;
  }

  void openPlayer() async {
    await assetsAudioPlayer.open(
      Playlist(audios: [
        Audio(
          'assets/images/burna.mp3',
          metas: Metas(
            id: 'For my hand ',
            title: 'For my hand ',
            artist: 'burna boy',
            album: 'RockAlbum',
            image: const MetasImage.network(
              'assets/images/formyhand.jpg',
            ),
          ),
        ),
        Audio(
          'assets/images/nolele.mp3',
          metas: Metas(
            id: 'No lele',
            title: 'No lele',
            artist: 'Wizkid',
            album: 'OnlineAlbum',
            image: const MetasImage.network('assets/images/wizkid.jpg'),
          ),
        ),
      ]),
      showNotification: true,
      autoStart: false,
      loopMode: LoopMode.playlist,
    );
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  Widget ui(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
    
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              SizedBox(
                height: 60,
                width: 60,
                child: Shadowbox(
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Text('P L A Y L I S T '),
              SizedBox(
                height: 60,
                width: 60,
                child: Shadowbox(
                  child: Icon(Icons.menu),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                child: Shadowbox(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          realtimePlayingInfos
                              .current!.audio.audio.metas.image!.path,
                          fit: BoxFit.cover,
                        ))),
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height * 0.01,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          realtimePlayingInfos.current!.audio.audio.metas.title
                              .toString(),
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(realtimePlayingInfos
                            .current!.audio.audio.metas.artist
                            .toString()),
                      ],
                    ),
                  ),
                ],
              ),
          SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Shadowbox(
                  child: linearprogressbar(realtimePlayingInfos.currentPosition,
                      realtimePlayingInfos.duration)),
              SizedBox(
               height:MediaQuery.of(context).size.height * 0.03
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  gettime(realtimePlayingInfos.currentPosition),
                  IconButton(
                      onPressed: (() {
                        _toggleshuffle();
                      }),
                      icon: _shuffled
                          ? Icon(
                              Icons.shuffle,
                              size: 30,
                            )
                          : Icon(Icons.shuffle)),
                  IconButton(
                      onPressed: () {
                    _togglelooping();
                      },
                      icon:  realtimePlayingInfos.loopMode == LoopMode.single
                          ? Icon(
                              Icons.repeat_one,
                              size: 30,
                            )
                          :    
                     Icon(Icons.repeat,
                              )  ),
                  gettime(realtimePlayingInfos.duration),
                ],
              ),
            SizedBox(
               height:MediaQuery.of(context).size.height * 0.04
              ),
              SizedBox(
                height: 80,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Shadowbox(
                            child: IconButton(
                                onPressed: (() {
                                  assetsAudioPlayer.previous();
                                }),
                                icon: const Icon(Icons.skip_previous,
                                    size: 32)))),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Shadowbox(
                              child: IconButton(
                                  onPressed: (() {
                                    assetsAudioPlayer.playOrPause();
                                  }),
                                  icon: realtimePlayingInfos.isPlaying
                                      ? const Icon(Icons.pause, size: 32)
                                      : const Icon(Icons.play_arrow,
                                          size: 32))),
                        )),
                    Expanded(
                        child: Shadowbox(
                            child: IconButton(
                                onPressed: (() {
                                  assetsAudioPlayer.next();
                                }),
                                icon: const Icon(Icons.skip_next, size: 32)))),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget linearprogressbar(Duration currentPosition, Duration duration) {
    return LinearPercentIndicator(
      lineHeight: 10.0,
      animationDuration: 2500,
      progressColor: Colors.green,
      percent: currentPosition.inSeconds / duration.inSeconds,
       
    );
  }

  Widget gettime(Duration duration) {
    return Text(
      transformString(duration.inSeconds),
    );
  }

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${(seconds % 60) < 10 ? 0 : ''}${(seconds % 60)}';
    return '$minuteString:$secondString';
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: assetsAudioPlayer.builderRealtimePlayingInfos(builder:
                    (context, RealtimePlayingInfos? realtimePlayingInfos) {
                  if (realtimePlayingInfos == null) {
                    return const SizedBox();
                  } else {
                    return ui(realtimePlayingInfos);
                  }
                })),
          )),
      desktop: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 3,
                child: Shadowbox(
                  child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            assetsAudioPlayer.builderRealtimePlayingInfos(
                                builder: (context,
                                    RealtimePlayingInfos?
                                        realtimePlayingInfos) {
                              if (realtimePlayingInfos == null) {
                                return const SizedBox();
                              } else {
                                return ui(realtimePlayingInfos);
                              }
                            }),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          )),
      tablet: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                child: Shadowbox(
                  child: SafeArea(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          assetsAudioPlayer.builderRealtimePlayingInfos(
                              builder: (context,
                                  RealtimePlayingInfos?
                                      realtimePlayingInfos) {
                            if (realtimePlayingInfos == null) {
                              return const SizedBox();
                            } else {
                              return ui(realtimePlayingInfos);
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
