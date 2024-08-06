import 'dart:async';

import 'package:logger/logger.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioController {
  var log = Logger();
  SoLoud? _soloud;

  Future<void> initialize() async {
    _soloud = SoLoud.instance;
    await _soloud!.init();
  }

  void dispose() {
    _soloud!.deinit();
  }

  Future<void> playSound(String assetKey) async {
    final source = await _soloud!.loadAsset(assetKey);
    log.d("playing sound");
    await _soloud!.play(source);
  }

  Future<void> startMusic() async {
    log.w('Not implemented yet.');
  }

  void fadeOutMusic() {
    log.w('Not implemented yet.');
  }

  void applyFilter() {
    // TODO
  }

  void removeFilter() {
    // TODO
  }
}
