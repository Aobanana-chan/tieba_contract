/// 契约层的值类型：跨接口复用的简单数据结构。
library;

/// 关注的吧。
class LikeForumInfo {
  final String forumId;
  final String forumName;
  final String avatar;

  /// 吧内等级。
  final String levelId;

  /// 是否已签到：`"0"` / `"1"`。
  final String isSign;

  const LikeForumInfo({
    required this.forumId,
    required this.forumName,
    required this.avatar,
    required this.levelId,
    required this.isSign,
  });
}

/// 本人的账号信息（登录态相关）。
class MyUserData {
  final int id;
  final int uid;
  final String name;
  final String nameShow;
  final bool isLogin;
  final bool isVerify;
  final String portrait;

  /// 头像完整 URL（无头像时为空串）。
  final String portraitUrl;
  final int likeForumNum;
  final int postNum;
  final int concernNum;
  final int fansNum;
  final String intro;
  final int? userSex;

  const MyUserData({
    required this.id,
    required this.uid,
    required this.name,
    required this.nameShow,
    required this.isLogin,
    required this.isVerify,
    required this.portrait,
    required this.portraitUrl,
    required this.likeForumNum,
    required this.postNum,
    required this.concernNum,
    required this.fansNum,
    required this.intro,
    required this.userSex,
  });
}

/// 待上传图片；[path] 指向宿主提供的本地文件。
class UploadFile {
  /// 本地文件路径。
  final String path;

  /// 图片宽高。
  final int width;
  final int height;

  /// 宿主相册资源 id；官方上传 resourceId 由实现根据文件 MD5 计算。
  final String resourceId;

  /// 文件字节数；为空时由实现方读取文件获取。
  final int? size;

  /// 实际图片字节的发送进度（不含 multipart 开销）。
  final void Function(int sent, int total)? onProgress;

  const UploadFile({
    required this.path,
    required this.width,
    required this.height,
    required this.resourceId,
    this.size,
    this.onProgress,
  });
}

/// 单个吧签到的结果。
class SignResult {
  /// 是否签到成功（含「今日已签到」）。
  final bool ok;

  /// 给用户看的文案（成功含排名/经验，失败含原因）。
  final String message;

  /// 签到后的等级经验值（拿不到时空串）。
  final String levelupScore;

  /// 本次签到获得的经验（拿不到时为 `"0"`）。
  final String bonusPoint;

  const SignResult({
    required this.ok,
    required this.message,
    this.levelupScore = '',
    this.bonusPoint = '0',
  });
}
