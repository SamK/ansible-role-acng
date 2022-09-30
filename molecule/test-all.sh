#!/usr/bin/env bash
# Execute ALL THE TESTS (alternative to Github actions)

set -e

for MOLECULE_DISTRO in $(yq -o tsv '.jobs.Molecule.strategy.matrix.distro' <  .github/workflows/ansible.yml);
do
    export MOLECULE_DISTRO
    molecule test --all
done

echo Finished all tests successfully!
