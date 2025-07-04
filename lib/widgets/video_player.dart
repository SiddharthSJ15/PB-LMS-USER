import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isVideoPlaying = false;
  double _currentVideoPosition = 0;
  double _videoDuration = 0;
  Timer? _positionTimer;
  String _currentQuality = 'auto';
  final List<String> _qualities = [
    'auto',
    '144p',
    '240p',
    '360p',
    '480p',
    '720p',
    '1080p',
  ];
  bool _showQualityMenu = false;

  // Define skip duration in seconds
  final int _skipDuration = 10;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        enableJavaScript: true,
        playsInline: true,
        strictRelatedVideos: true,
        pointerEvents: PointerEvents.none,
      ),
    );

    _controller.listen((event) {
      if (event.playerState == PlayerState.playing) {
        setState(() {
          _isVideoPlaying = true;
        });
        _startPositionTimer();
      } else if (event.playerState == PlayerState.paused) {
        setState(() {
          _isVideoPlaying = false;
        });
      }
    });

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller.listen((event) async {
      if (event.playerState == PlayerState.playing) {
        final duration = await _controller.duration;
        final quality = await _controller.videoQuality;
        setState(() {
          _videoDuration = duration.toDouble();
          if (quality != null) {
            _currentQuality = quality;
          }
        });
      }
    });
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (
      timer,
    ) async {
      if (mounted) {
        final position = await _controller.currentTime;
        setState(() {
          _currentVideoPosition = position.toDouble();
        });
      }
    });
  }

  Future<void> _changeQuality(String quality) async {
    try {
      await _controller.setPlaybackQuality(quality);
      setState(() {
        _currentQuality = quality;
        _showQualityMenu = false;
      });
    } catch (e) {
      print('Error changing quality: $e');
    }
  }

  String _formatDuration(double seconds) {
    final Duration duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleVideoPlayback() async {
    try {
      if (_isVideoPlaying) {
        await _controller.pauseVideo();
        _positionTimer?.cancel();
      } else {
        await _controller.playVideo();
        _startPositionTimer();
      }
      setState(() {
        _isVideoPlaying = !_isVideoPlaying;
      });
    } catch (e) {
      print('Error toggling playback: $e');
    }
  }

  // Add skip forward function
  Future<void> _skipForward() async {
    try {
      double newPosition = _currentVideoPosition + _skipDuration;
      // Make sure we don't skip past the end of the video
      if (newPosition > _videoDuration) {
        newPosition = _videoDuration;
      }

      await _controller.seekTo(seconds: newPosition, allowSeekAhead: true);

      setState(() {
        _currentVideoPosition = newPosition;
      });
    } catch (e) {
      print('Error skipping forward: $e');
    }
  }

  // Add skip backward function
  Future<void> _skipBackward() async {
    try {
      double newPosition = _currentVideoPosition - _skipDuration;
      // Make sure we don't go below 0
      if (newPosition < 0) {
        newPosition = 0;
      }

      await _controller.seekTo(seconds: newPosition, allowSeekAhead: true);

      setState(() {
        _currentVideoPosition = newPosition;
      });
    } catch (e) {
      print('Error skipping backward: $e');
    }
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final videoHeight = screenSize.height * 0.75;
    final videoWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Video Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.close();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: videoWidth,
                    height: videoHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: YoutubePlayer(
                        controller: _controller,
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_formatDuration(_currentVideoPosition)),
                      Expanded(
                        child: Slider(
                          value: _currentVideoPosition.clamp(0.0, _videoDuration),
                          min: 0.0,
                          max: _videoDuration,
                          onChanged: (value) async {
                            setState(() {
                              _currentVideoPosition = value;
                            });
                            await _controller.seekTo(
                              seconds: value,
                              allowSeekAhead: true,
                            );
                          },
                        ),
                      ),
                      Text(_formatDuration(_videoDuration)),
                    ],
                  ),
                  // Controls - Responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 300;
        
                      if (isNarrow) {
                        // Stacked layout for narrow screens
                        return Column(
                          children: [
                            // Main playback controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.replay_10),
                                  tooltip: 'Skip back $_skipDuration seconds',
                                  iconSize: 28,
                                  onPressed: () => _skipBackward(),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    _isVideoPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  iconSize: 36,
                                  onPressed: _toggleVideoPlayback,
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.forward_10),
                                  tooltip: 'Skip forward $_skipDuration seconds',
                                  iconSize: 28,
                                  onPressed: () => _skipForward(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Quality selector on separate row
                            PopupMenuButton<String>(
                              initialValue: _currentQuality,
                              onSelected: _changeQuality,
                              offset: const Offset(0, -10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => _qualities.map((quality) {
                                final isSelected = quality == _currentQuality;
                                return PopupMenuItem<String>(
                                  value: quality,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          quality.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? Colors.blue
                                                : null,
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.hd,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.grey[700],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _currentQuality.toUpperCase(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white70
                                            : Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.grey[700],
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        );
                      } else {
                        // Single row layout for wider screens
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10),
                              tooltip: 'Skip back $_skipDuration seconds',
                              iconSize: 32,
                              onPressed: () => _skipBackward(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 40,
                              onPressed: _toggleVideoPlayback,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.forward_10),
                              tooltip: 'Skip forward $_skipDuration seconds',
                              iconSize: 32,
                              onPressed: () => _skipForward(),
                            ),
                            const SizedBox(width: 16),
                            // Quality selector
                            PopupMenuButton<String>(
                              initialValue: _currentQuality,
                              onSelected: _changeQuality,
                              offset: const Offset(0, -10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => _qualities.map((quality) {
                                final isSelected = quality == _currentQuality;
                                return PopupMenuItem<String>(
                                  value: quality,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          quality.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? Colors.blue
                                                : null,
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.hd,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.grey[700],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _currentQuality.toUpperCase(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white70
                                            : Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.grey[700],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on YoutubePlayerController {
  get videoQuality => null;

  setPlaybackQuality(String quality) {}
}
