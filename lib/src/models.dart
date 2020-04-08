class Point {
  final int x;
  final int y;
  Point({
    this.x,
    this.y,
  });

  Point copyWith({
    int x,
    int y,
  }) {
    return Point(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  String toString() => 'Point(x: $x, y: $y)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Point &&
      o.x == x &&
      o.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Rect {
  final int left;
  final int top;
  final int right;
  final int bottom;
  Rect({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  int get width => right - left;
  int get height => bottom - top;

  Rect copyWith({
    int left,
    int top,
    int right,
    int bottom,
  }) {
    return Rect(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }

  @override
  String toString() {
    return 'Rect(left: $left, top: $top, right: $right, bottom: $bottom)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Rect &&
      o.left == left &&
      o.top == top &&
      o.right == right &&
      o.bottom == bottom;
  }

  @override
  int get hashCode {
    return left.hashCode ^
      top.hashCode ^
      right.hashCode ^
      bottom.hashCode;
  }
}
