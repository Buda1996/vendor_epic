for combo in $(curl -s https://raw.githubusercontent.com/Epic-OS/hudson/master/epic-build-targets | sed -e 's/#.*$//' | grep E-L5 | awk {'print $1'})
do
    add_lunch_combo $combo
done
