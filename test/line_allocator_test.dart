import 'package:evereactor/line_allocator.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('Basic test', () {
    var lineAllocator = LineAllocator();
    int numLines = 9;
    List<Tuple2<int, int>> jobs = [
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(2, 10),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [4, 4, 1]);
  });

  test('Permute the input to permute the output', () {
    var lineAllocator = LineAllocator();
    int numLines = 9;
    List<Tuple2<int, int>> jobs = [
      Tuple2(100, 2),
      Tuple2(200, 2),
      Tuple2(2, 10),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [3, 5, 1]);
    jobs = [
      Tuple2(100, 2),
      Tuple2(2, 10),
      Tuple2(200, 2),
    ];
    allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [3, 1, 5]);
    jobs = [
      Tuple2(2, 10),
      Tuple2(100, 2),
      Tuple2(200, 2),
    ];
    allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [1, 3, 5]);
  });

  test('Fail if there are more jobs than lines', () {
    var lineAllocator = LineAllocator();
    int numLines = 1;
    List<Tuple2<int, int>> jobs = [
      Tuple2(200, 3),
      Tuple2(16, 1),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, []);
  });

  test('Each job gets one line if the number of jobs is equal to the number of lines', () {
    var lineAllocator = LineAllocator();
    int numLines = 4;
    List<Tuple2<int, int>> jobs = [
      Tuple2(200, 3),
      Tuple2(84, 5),
      Tuple2(200, 1),
      Tuple2(16, 1),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [1, 1, 1, 1]);
  });

  test('If there is only one job then it gets all the lines', () {
    var lineAllocator = LineAllocator();
    int numLines = 10;
    List<Tuple2<int, int>> jobs = [
      Tuple2(100, 3),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, [10]);
  });

  test('Algorithm does not allocate to more than 32 lines at a time', () {
    var lineAllocator = LineAllocator();
    int numLines = 33;
    List<Tuple2<int, int>> jobs = [
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
      Tuple2(200, 2),
    ];
    var allocation = lineAllocator.allocateLines(numLines, jobs);
    expect(allocation, []);
  });
}
