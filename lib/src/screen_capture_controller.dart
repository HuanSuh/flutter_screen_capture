part of flutter_screen_capture;

enum _ScreenCaptureState { idle, capture, saving, preview }

class ScreenCaptureController extends ChangeNotifier {
  final GlobalKey _captureKey = GlobalKey();
  final bool _showPreview;
  final double pixelRatio;
  ScreenCaptureController._(
    this._showPreview,
    this.pixelRatio,
  );

  _ScreenCaptureState _state = _ScreenCaptureState.idle;
  _setState(_ScreenCaptureState value) {
    _state = value;
    notifyListeners();
  }

  bool get _onCapture => _state != _ScreenCaptureState.idle;

  /// You can edit widget for capture. (ex: add watermark)
  bool get isOnCapture =>
      _state == _ScreenCaptureState.capture ||
      _state == _ScreenCaptureState.saving;

  File? _previewFile;

  Future<File?> capture() async {
    if (_onCapture) return null;

    bool isGranted = await Permission.photosAddOnly.request().then((status) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
      return true;
    });
    if (!isGranted) return null;

    _setState(_ScreenCaptureState.capture);
    Future.delayed(
      const Duration(milliseconds: 80),
      () => _setState(_ScreenCaptureState.saving),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      _previewFile = await WidgetToImage.repaintBoundaryToImage(
        _captureKey,
        pixelRatio: pixelRatio,
      ).then((bytes) async {
        Map<Object, Object>? savedResult = await ImageGallerySaver.saveImage(
          bytes.buffer.asUint8List(0),
          isReturnImagePathOfIOS: true,
        );
        String? fileUri =
            savedResult == null ? null : savedResult['filePath'] as String?;
        if (fileUri != null && fileUri.isNotEmpty) {
          return uri2file.toFile(fileUri);
        }
        throw Exception();
      }).catchError((e) {
        throw e;
      }).whenComplete(() {
        if (_showPreview) {
          _setState(_ScreenCaptureState.preview);
          Future.delayed(
            const Duration(seconds: 2),
            () => _setState(_ScreenCaptureState.idle),
          );
        } else {
          _setState(_ScreenCaptureState.idle);
        }
      });
      return _previewFile;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> share(File file) {
    return file.exists().then((isExists) {
      if (isExists) {
        return Share.shareFiles([file.path]).then((_) => true);
      }
      return false;
    });
  }
}
