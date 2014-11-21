fuel-library-test
=================
A script to perform dryrun tests for fuel-library manifests

Usage
-----

```bash
export MODULE_PATH="/path-to-your-copy-of/fuel-library/deployment/puppet"
./puppet-test.sh [compile|apply]
    compile - runs custom catalog compilation function ("res") and saves catalogs into logfiles
    apply   - runs puppet apply with '--noop' option and saves output into logfiles
```

Available ENV variables
-----------------------

* ```FUEL_VER``` - determines what version of yamls to use. Check ```astute-yaml``` directory for available versions.
* ```MODULE_PATH``` - puppet ```--modulepath``` parameter. Sets the directory fuel-library manifests stored in.
* ```SITE_PP``` - full path and filename of ```site.pp``` you want to test. If not specified, script will look for it in your ```MODULE_PATH```.
* ```LOG_DIR``` - directory for test logs.
* ```YAMLS``` - list of particular astute.yaml settings you want to test. Example:

Usage Examples
--------------

* Run tests against ```simple_nova_flat_cei.controller.yaml``` config:
```bash
YAMLS=simple_nova_flat_cei.controller.yaml ./puppet-test.sh
```


Output example
--------------

```
./puppet-test.sh
Puppet version: 3.4.3

Testing with puppet 'res' command

YAML EXAMPLE                                                          RESULT     LOGFILE
Running ha_neut_vlan_cei.compute.yaml ...                             OK         /tmp/log/ha_neut_vlan_cei.compute.yaml.log
Running ha_neut_vlan_sah_mur_cei.compute.yaml ...                     OK         /tmp/log/ha_neut_vlan_sah_mur_cei.compute.yaml.log
Running ha_neut_vlan_sah_mur_cei.cinder.yaml ...                      OK         /tmp/log/ha_neut_vlan_sah_mur_cei.cinder.yaml.log
Running simple_nova_flat_cei.cinder.yaml ...                          OK         /tmp/log/simple_nova_flat_cei.cinder.yaml.log
Running ha_neut_vlan_cei.controller.yaml ...                          OK         /tmp/log/ha_neut_vlan_cei.controller.yaml.log
Running simple_neut_gre_ceph_sah_mur_cei.primary-mongo.yaml ...       OK         /tmp/log/simple_neut_gre_ceph_sah_mur_cei.primary-mongo.yaml.log
Running simple_nova_flat_cei.controller.yaml ...                      OK         /tmp/log/simple_nova_flat_cei.controller.yaml.log
Running simple_neut_gre_ceph_sah_mur_cei.controller.yaml ...          OK         /tmp/log/simple_neut_gre_ceph_sah_mur_cei.controller.yaml.log
Running ha_neut_vlan_cei.primary-controller.yaml ...                  OK         /tmp/log/ha_neut_vlan_cei.primary-controller.yaml.log
Running simple_nova_flat_cei.compute.yaml ...                         OK         /tmp/log/simple_nova_flat_cei.compute.yaml.log
Running simple_neut_gre_ceph_sah_mur_cei.ceph-osd.yaml ...            OK         /tmp/log/simple_neut_gre_ceph_sah_mur_cei.ceph-osd.yaml.log
Running ha_neut_vlan_sah_mur_cei.primary-controller.yaml ...          OK         /tmp/log/ha_neut_vlan_sah_mur_cei.primary-controller.yaml.log
Running simple_neut_gre_ceph_sah_mur_cei.compute.yaml ...             OK         /tmp/log/simple_neut_gre_ceph_sah_mur_cei.compute.yaml.log
Running ha_neut_vlan_sah_mur_cei.controller.yaml ...                  OK         /tmp/log/ha_neut_vlan_sah_mur_cei.controller.yaml.log
```
