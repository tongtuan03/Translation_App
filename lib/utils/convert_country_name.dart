String removeParentheses(String input) {
  return input.replaceAll(RegExp(r'\s*\(.*?\)'), '');
}