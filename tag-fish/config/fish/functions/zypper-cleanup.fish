function zypper-cleanup
  set thingsToClean (zypper pa --unneeded|tail -n+5|awk -F'|' '{print $3}')
  if expr (count $thingsToClean) '>' 2
    echo $thingsToClean|xargs sudo zypper rm -u 
  else
    echo "Nothing to cleanup"
  end
end
