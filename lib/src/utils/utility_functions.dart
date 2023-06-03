String getInitials(String organizationName) {
  List<String> words = organizationName.split(" ");
  String initials = "";
  int num = 5;
  if (num < words.length) {
    num = words.length;
  }
  for (var i = 0; i < num; i++) {
    initials += words[i][0];
  }
  return initials;
}
