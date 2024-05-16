part of '../flutter_screen_capture.dart';

class ScreenCapturePreview extends StatelessWidget {
  final ScreenCaptureController controller;
  const ScreenCapturePreview(this.controller, {super.key});

  static Future<void> show(
      BuildContext context, ScreenCaptureController controller) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () => controller.share(controller._previewFile!),
    );
    return _showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScreenCapturePreview(controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            onPressed: () => controller.share(controller._previewFile!),
            icon: Icon(
              Platform.isIOS ? Icons.ios_share : Icons.share,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Image.file(controller._previewFile!, fit: BoxFit.contain),
      ),
    );
  }
}
