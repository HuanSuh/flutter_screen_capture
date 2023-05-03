part of flutter_screen_capture;

typedef ScreenCaptureBuilder = Widget Function(
    BuildContext context, ScreenCaptureController controller);
typedef ScreenCaptureLayoutBuilder = Widget Function(BuildContext context,
    ScreenCaptureController controller, Widget captureView);

class ScreenCaptureView extends StatefulWidget {
  final ScreenCaptureLayoutBuilder layoutBuilder;
  final ScreenCaptureBuilder captureBuilder;
  final bool showPreview;
  final double pixelRatio;
  final Widget? watermark;
  final Color? backgroundColor;
  final Widget? loadingWidget;

  const ScreenCaptureView({
    required this.layoutBuilder,
    required this.captureBuilder,
    this.showPreview = true,
    this.pixelRatio = 4.0,
    this.watermark,
    this.backgroundColor,
    this.loadingWidget,
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenCaptureView> createState() => _ScreenCaptureViewState();
}

class _ScreenCaptureViewState extends State<ScreenCaptureView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScreenCaptureController>(
      create: (_) =>
          ScreenCaptureController._(widget.showPreview, widget.pixelRatio),
      child: Consumer<ScreenCaptureController>(
        builder: (ctx, ctrl, _) {
          return Stack(
            children: [
              widget.layoutBuilder.call(
                ctx,
                ctrl,
                RepaintBoundary(
                  key: ctrl._captureKey,
                  child: Container(
                    color: widget.backgroundColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (ctrl.isOnCapture && widget.watermark != null)
                          widget.watermark!,
                        widget.captureBuilder.call(ctx, ctrl),
                      ],
                    ),
                  ),
                ),
              ),
              if (ctrl._onCapture)
                GestureDetector(
                  onTap: (ctrl._state == _ScreenCaptureState.preview)
                      ? () => ctrl._setState(_ScreenCaptureState.idle)
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: ctrl._state == _ScreenCaptureState.capture
                        ? Colors.black54
                        : Colors.black26,
                    alignment: Alignment.center,
                    child: ctrl._state == _ScreenCaptureState.saving
                        ? widget.loadingWidget ?? const CupertinoActivityIndicator()
                        : null,
                  ),
                ),
              if (ctrl._state == _ScreenCaptureState.preview &&
                  ctrl._previewFile != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () => ScreenCapturePreview.show(context, ctrl),
                    child: Image.file(
                      ctrl._previewFile!,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
