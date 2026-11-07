// ignore_for_file: constant_identifier_names

/// 契约层公共常量。
library;

/// 官方头像前缀：拼接 `portrait` 得到完整头像地址。
///
/// `portrait` 已是绝对地址时改用 [resolveAvatarUrl]。
const String AUTHOR_AVATAR = "http://tb.himg.baidu.com/sys/portrait/item/";

/// 把 `portrait` 解析成可直接加载的头像地址。
///
/// 已是绝对地址时原样返回，否则拼上 [AUTHOR_AVATAR]。
String resolveAvatarUrl(String portrait) {
  final String value = portrait.trim();
  if (value.isEmpty) {
    return '';
  }
  final Uri? uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
    return value;
  }
  return '$AUTHOR_AVATAR$value';
}

/// 登录域名（网页登录入口的 cookie 归属域）。
const String BAIDU_URL = "https://www.baidu.com";

/// passport 域名（STOKEN 等凭证的归属域）。
const String BAIDU_PASSPORT_URL = "https://passport.baidu.com";
