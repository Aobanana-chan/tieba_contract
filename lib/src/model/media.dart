/// 媒体：帖子配图与上传结果。
library;

/// 回复里贴的图。
class TiebaMedia {
  String bigPic;
  String originPic;

  TiebaMedia({required this.bigPic, required this.originPic});
}

/// 上传成功的图片（回帖配图预览 / 内容串用）。
class TiebaUploadedImage {
  final String picId;
  final int width;
  final int height;
  final String? url;

  TiebaUploadedImage({
    required this.picId,
    required this.width,
    required this.height,
    this.url,
  });
}
