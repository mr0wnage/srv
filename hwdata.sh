#!/bin/bash 
w
echo
echo "Hardware data:"
echo

cpu_count="$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)"
cpu_cores="$(cat /proc/cpuinfo | grep "siblings" | uniq | tr -d ' ' | cut -d: -f2)"
cpu_type="$(cat /proc/cpuinfo | grep "model name" | uniq | tr -s ' ' | cut -d: -f2)"

if [ "$cpu_count" -gt 0 ] ; then
  for i in $(seq 1 $cpu_count) ; do
    cpu_spec_type="$(echo "$cpu_type" | head -n$i | tail -n1)"
    echo -n "   CPU$i:$cpu_spec_type"
    cpu_spec_cores="$(echo "$cpu_cores" | head -n$i | tail -n1)"
    if [ "$cpu_spec_cores" -gt 1 ] ; then
      echo " (Cores $cpu_spec_cores)"
    else
      echo
    fi
  done
else
  echo "   CPU: $cpu_type"
fi

ram=$(free -m | grep Mem: | tr -s ' ' | cut -d' ' -f2)
echo "   Memory:  $ram MB"

i=0
total=0
while read line; do
  if [ -n "$line" ]; then
    items=( $line )
    drive="/dev/${items[3]}"
    size=$((${items[2]} * 1024))

    let total=total+$size
    realsize=$size
    si_size=$size
    unit=''
    while [ $si_size -gt 10000 ]; do
      realsize=$[ $realsize / 1000 ]
      si_size=$[ $si_size / 1024 ]
      case "$unit" in
        K) unit='M';;
        M) unit='G';;
        G) unit='T';;
        *) unit='K';;
      esac
    done

    echo -n "   Disk $drive: $realsize ${unit}B (=> $si_size ${unit}iB) "

    isempty=$(timeout 3 parted -m -s $drive print 2>&1 | grep unrecognised | cut -d ' ' -f 3-)

    if [ -n "$isempty" ]; then
      echo "doesn't contain a valid partition table"
    else
      echo ""
    fi

    let i=i+1
  fi
done <<< "$(cat /proc/partitions | egrep "nvme[0-9]+n[0-9]$|[hsv]d[a-z]$" | sort -b -k 4 -V)"

if [ $total -gt 0 ]; then
  unit=''
  while [ $total -gt 10000 ]; do
    total=$[ $total / 1024 ]
    case "$unit" in
      K) unit='M';;
      M) unit='G';;
      G) unit='T';;
      *) unit='K';;
    esac
  done

  echo -n "   Total capacity $total ${unit}iB with $i Disk"
  if [ $i -gt 1 ]; then
    echo "s"
  else
    echo ""
  fi
fi


raid="$(lspci | egrep "(3ware|Adaptec|LSI)" | cut -d ' ' -f2- | sed -e 's/bus controller: //' -e 's/(rev.*)//' -e 's/Inc //')"
[ "$raid" ] && echo "   $raid"

echo

df -h | grep -e "Avail\|\/dev\/" | grep -v tmpfs
