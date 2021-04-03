import 'dart:math';

enum TileState {
  EMPTY, CROSS, ZERO
}

List<List<TileState>> chunk(List<TileState> list, int size) {
  return List.generate(
      (list.length / size).ceil(),
          (index) => list.sublist(index * size, min(index * size + size, list.length)));
}
