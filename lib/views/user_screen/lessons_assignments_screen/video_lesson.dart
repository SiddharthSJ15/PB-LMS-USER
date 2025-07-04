import 'package:flutter/material.dart';
import 'package:pb_lms/widgets/video_player.dart';

class VideoLesson extends StatefulWidget {
  final String url;
  const VideoLesson({super.key, required this.url});

  @override
  State<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends State<VideoLesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        // child:
        // Column(
        //   children: [
        //     Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: VideoPlayerScreen(url: widget.url),
        ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
