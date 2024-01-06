int levenshteinDistance(String s, String t) {
  int lenS = s.length;
  int lenT = t.length;
  var matrix =
      List<List<int>>.generate(lenS + 1, (_) => List<int>.filled(lenT + 1, 0));

  for (var i = 0; i <= lenS; i++) {
    matrix[i][0] = i;
  }

  for (var j = 0; j <= lenT; j++) {
    matrix[0][j] = j;
  }

  for (var i = 1; i <= lenS; i++) {
    for (var j = 1; j <= lenT; j++) {
      var cost = s[i - 1] == t[j - 1] ? 0 : 1;
      matrix[i][j] = minOfThree(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost);
    }
  }

  return matrix[lenS][lenT];
}

int minOfThree(int a, int b, int c) {
  return min(min(a, b), c);
}

int min(int a, int b) {
  return a < b ? a : b;
}

void main() {
  String target = "safvan";
  List<String> list = ["Safvan", "amina", "Husain", "Safn", "Safvana", "muha"];

  list.sort((a, b) {
    int distanceA = levenshteinDistance(a.toLowerCase(), target.toLowerCase());
    int distanceB = levenshteinDistance(b.toLowerCase(), target.toLowerCase());
    return distanceA.compareTo(distanceB);
  });

  print(list);
}

//RJ26RC1743