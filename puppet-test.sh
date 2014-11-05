#!/bin/bash

echo -n "Puppet version: "
puppet --version || exit 1

# Usage
function usage {
  echo -e "\n\nUsage:\n\t$0 [compile|apply]\n"
  echo -e "\tcompile\t- runs custom catalog compilation function and saves catalogs into logfiles"
  echo -e "\tapply\t- runs puppet apply with '--noop' option and saves output into logfiles"
  echo
}

# Define variables
if [ -z "$FUEL_VER" ] ; then
  FUEL_VER="6.0"
fi

if [ -z "$SITE_PP"] ; then
  SITE_PP="/zkskksjkdjd/dkldjdkjdkd/dkdkdjdkjd/dkdjdkjd"
fi

if [ -z "$MODULE_PATH" ] ; then
  MODULE_PATH='/tmp/modules/upstream:/tmp/modules/fuel-library/deployment/puppet'
fi

if [ -z "$YAML_BASE"] ; then
  YAML_BASE="./astute-yaml/$FUEL_VER"
fi

if [ -z "$YAMLS" ] ; then
  YAMLS=$(find $YAML_BASE/ -name \*yaml -printf "%f\n")
fi

if [ -z "$LOG_DIR" ] ; then
  LOG_DIR="/tmp/modules"
fi

if [ -z "$1" ] ; then
  COMMAND="res"
elif [ "$1" == "apply" ] ; then
  COMMAND="apply --noop"
elif [ "$1" == "compile" ] ; then
  COMMAND="res"
else
  usage
  exit 1
fi

# Find site.pp
IFS=':' read -ra MARR <<< "$MODULE_PATH"
for i in "${MARR[@]}"; do
  if [ -f "$i/osnailyfacter/examples/site.pp" ] ; then
    SITE_PP="$i/osnailyfacter/examples/site.pp"
    break
  fi
done

if ! [ -f "$SITE_PP" ] ; then
  echo "No site.pp found in your MODULE_PATH"
  exit 1
fi

# Check/prepare some stuff
mkdir -p "$LOG_DIR"
mkdir -p /etc/fuel
if [ "$COMMAND" == "res" ] ; then
  PLIBDIR=$(puppet config print libdir)
  [ -f "$PLIBDIR/puppet/application/res.rb" ] || (
    mkdir -p $PLIBDIR/puppet/application/
    curl -s https://raw.githubusercontent.com/dmitryilyin/fuel-tools/master/ruby/res.rb > "$PLIBDIR/puppet/application/res.rb"
  )
fi

# Let's rock-n-roll
echo -e "\nTesting with puppet '$COMMAND' command\n"
printf "%-70s%-10s %s\n" "YAML EXAMPLE" "RESULT" "LOGFILE"
for YAML in $YAMLS ; do
    printf "%-70s" "Running $YAML ..."
    cat "$YAML_BASE/$YAML" > /etc/fuel/astute.yaml
    ( FACTER_hostname=`awk '/^fqdn:/{print $2}' /etc/fuel/astute.yaml | cut -d. -f1` puppet $COMMAND -d -v --modulepath $MODULE_PATH $SITE_PP ; echo Exit code: $? ; echo ) &> $LOG_DIR/${YAML}.log
    if grep -q 'Exit code: 0' $LOG_DIR/${YAML}.log && ! grep -q 'Error: Could not apply complete catalog' $LOG_DIR/${YAML}.log ; then
        printf "%-10s %s\n" "OK" "$LOG_DIR/${YAML}.log"
    else
        printf "%-10s %s\n" "FAILED" "$LOG_DIR/${YAML}.log"
    fi
done
