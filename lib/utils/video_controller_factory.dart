import 'package:video_player/video_player.dart';

import 'video_controller_factory_stub.dart'
    if (dart.library.io) 'video_controller_factory_io.dart'
    if (dart.library.html) 'video_controller_factory_stub.dart' as impl;

VideoPlayerController createVideoController(Uri uri) => impl.createVideoController(uri);
