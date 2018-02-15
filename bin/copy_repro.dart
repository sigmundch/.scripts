import 'dart:io';

main(args) {
  if (args.length == 0) {
    print('usage: copy_repro dir');
    exit(1);
  }

  for (var file in new Directory(args[0]).listSync(recursive: true)) {
    var name = file.path;
    var contents = file.readAsStringSync().replaceAll('\n', '\n    ');
    print('$name:\n    $contents');
  }
}
