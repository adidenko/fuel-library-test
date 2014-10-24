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
