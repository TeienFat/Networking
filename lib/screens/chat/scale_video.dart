import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ScaleVideo extends StatefulWidget {
  ScaleVideo({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  State<ScaleVideo> createState() => _ScaleVideoState();
}

void _saveNetworkVideo(String videoUrl) async {
  GallerySaver.saveVideo(videoUrl, albumName: 'Networking Video')
      .then((success) {
    if (success != null && success) {
      Fluttertoast.showToast(
          msg: "Lưu video thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  });
}

class _ScaleVideoState extends State<ScaleVideo> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getVideoPosition() {
    var duration = Duration(
        milliseconds: _controller.value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.cancel_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _saveNetworkVideo(widget.videoUrl);
            },
            icon: Icon(Icons.download_sharp),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 5),
                    child: Row(
                      children: [
                        IconButton(
                          iconSize: 35,
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 5, right: 10),
                            child: Transform.scale(
                              scaleY: 1.2,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                    playedColor: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          getVideoPosition(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
