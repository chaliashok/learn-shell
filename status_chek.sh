echo STATED

stat_check() {
  if [ "$1" -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi
}

stat_check $?
echo ENDED