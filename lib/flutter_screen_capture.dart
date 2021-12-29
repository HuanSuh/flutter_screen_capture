library flutter_screen_capture;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:widget_to_image/widget_to_image.dart';

import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';

part 'src/bottom_sheet_with_top_padding.dart';
part 'src/screen_capture_preview.dart';
part 'src/screen_capture_controller.dart';
part 'src/screen_capture_view.dart';
