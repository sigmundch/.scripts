#!/bin/bash

function dart2js_bug_test {
  if [[ $# -eq 0 ]]; then
    echo "missing bug number"
    return
  fi
  # Accept either the bugid or the url of the form
  # https://code.google.com/p/dart/issues/detail?id=23058
  # (substitution removes everythign before the =)
  local id=${1/*=/}
  mkdir $id
  cd $id
  cat > pubspec.yaml <<-EOF
		name: bug_$id
		dependencies:
		  expect: {path: $HOME/dart/all/dart/pkg/expect}
EOF
  pub get
  cat > repro_$id.dart <<-EOF
		import "package:expect/expect.dart";
		main() {
		}
EOF
}

dart2js_bug_test $@
