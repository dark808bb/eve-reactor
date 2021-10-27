import 'dart:math';
import 'package:tuple/tuple.dart';

class LineAllocator {
  static const int _inf = 1 << 50;

  int _bestSoFar = _inf;
  final List<int> _solution = [];
  final List<int> _tempSolution = [];

  final List<Tuple3<int, int, int>> _jobs = [];

  void _branchAndBound(final int numLines, final int numJobs, final int solutionMaxTimeToBuild) {
    if (numJobs > numLines || numLines <= 0 || numJobs <= 0) {
      return;
    }
    final numRuns = _jobs[numJobs - 1].item1;
    final baseTimePerRun = _jobs[numJobs - 1].item2;
    final maxPartitionSize = numLines - numJobs + 1;
    final minPartitionSize = numJobs > 1 ? 1 : numLines;
    // choose partition size for this job
    for (int partitionSize = maxPartitionSize; partitionSize >= minPartitionSize; --partitionSize) {
      // calculate time to build on this partition
      final maxNumRunsPerLine = numRuns ~/ partitionSize + (numRuns % partitionSize == 0 ? 0 : 1);
      final timeToBuild = maxNumRunsPerLine * baseTimePerRun;
      final maxTimeToBuild = max(timeToBuild, solutionMaxTimeToBuild);
      if (numJobs == 1) {
        // reached a solution
        if (maxTimeToBuild < _bestSoFar) {
          _bestSoFar = maxTimeToBuild;
          _solution.clear();
          _solution.addAll(_tempSolution);
          _solution.add(partitionSize);
        }
      } else {
        // bound
        if (maxTimeToBuild >= _bestSoFar) {
          return;
        }
        // branch
        _tempSolution.add(partitionSize);
        _branchAndBound(numLines - partitionSize, numJobs - 1, maxTimeToBuild);
        _tempSolution.removeLast();
      }
    }
  }

  // jobs is a list of <runs, basetime> pairs
  List<int> allocateLines(int numLines, List<Tuple2<int, int>> jobs) {
    // Limit the size of input just to be safe since this is an exponential time algorithm
    // The time complexity may be something like p(numLines)^|jobs| where p is
    // the partition function https://en.wikipedia.org/wiki/Partition_function_(number_theory) ?
    if (numLines > 32) {
      return [];
    }

    _bestSoFar = _inf;
    _solution.clear();
    _jobs.clear();

    for (int i = 0; i < jobs.length; ++i) {
      _jobs.add(Tuple3(jobs[i].item1, jobs[i].item2, i));
    }

    // sort by 'work'
    _jobs.sort((x, y) {
      return x.item1 * x.item2 < y.item1 * y.item2 ? 0 : 1;
    });

    _branchAndBound(numLines, _jobs.length, 0);
    // the answer is in _solution.reversed

    // undo the above sorting
    int i = 0;
    for (int x in _solution.reversed) {
      _jobs[i] = Tuple3(_jobs[i].item3, x, 0);
      i += 1;
    }
    _jobs.sort((x, y) {
      return x.item1 < y.item1 ? 0 : 1;
    });

    List<int> solution = [];
    for (int k = 0; k < _solution.length; k++) {
      solution.add(_jobs[k].item2);
    }
    return solution;
  }
}
