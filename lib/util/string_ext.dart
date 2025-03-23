extension StringExt on String {
  String stripHtml() {
    final exp = RegExp('<[^>]*>', multiLine: true);
    return replaceAll(exp, '');
  }
}
