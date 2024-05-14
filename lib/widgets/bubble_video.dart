import 'package:networking/screens/chat/scale_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBubble extends StatefulWidget {
  const VideoBubble({super.key, required this.videoUrl, required this.isMe});
  final String videoUrl;
  final bool isMe;
  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  late VideoPlayerController _controller;
  bool _isMute = false;
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
        milliseconds: _controller.value.duration.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScaleVideo(
                  videoUrl: widget.videoUrl,
                )));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: !widget.isMe ? Radius.zero : const Radius.circular(12),
              topRight: widget.isMe ? Radius.zero : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_controller.value.isPlaying)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(50, 0, 0, 0),
                  ),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        _controller.play();
                      });
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (_controller.value.isPlaying)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(50, 0, 0, 0),
                    ),
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          _isMute = !_isMute;
                          if (_isMute) {
                            _controller.setVolume(0.0);
                          } else {
                            _controller.setVolume(1.0);
                          }
                        });
                      },
                      icon: Icon(
                        _isMute == false
                            ? Icons.volume_up_sharp
                            : Icons.volume_off_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!_controller.value.isPlaying)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Color.fromARGB(50, 0, 0, 0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      child: Text(
                        getVideoPosition(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
