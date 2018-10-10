#!/usr/bin/env bash

declare -a errors

function error_and_proceed() {
  errors+=("${1}")
  echo -e "kopsenv: ${0}: Test Failed: ${1}" >&2
}

function error_and_die() {
  echo -e "kopsenv: ${0}: ${1}" >&2
  exit 1
}

[ -n "$KOPSENV_DEBUG" ] && set -x
source $(dirname $0)/helpers.sh \
  || error_and_die "Failed to load test helpers: $(dirname $0)/helpers.sh"

echo "### Install latest version"
cleanup || error_and_die "Cleanup failed?!"

v=$(kopsenv list-remote | head -n 1)
(
  kopsenv install latest || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing latest version ${v}"

echo "### Install latest version with Regex"
cleanup || error_and_die "Cleanup failed?!"

v=0.8.8
(
  kopsenv install latest:^0.8 || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing latest version ${v} with Regex"

echo "### Install specific version"
cleanup || error_and_die "Cleanup failed?!"

v=0.7.13
(
  kopsenv install ${v} || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing specific version ${v}"

echo "### Install specific .kops-version"
cleanup || error_and_die "Cleanup failed?!"

v=0.9.1
echo ${v} > ./.kops-version
(
  kopsenv install || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing .kops-version ${v}"

echo "### Install latest:<regex> .kops-version"
cleanup || error_and_die "Cleanup failed?!"

v=$(kopsenv list-remote | grep -e '^0.8' | head -n 1)
echo "latest:^0.8" > ./.kops-version
(
  kopsenv install || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing .kops-version ${v}"

echo "### Install with ${HOME}/.kops-version"
cleanup || error_and_die "Cleanup failed?!"

if [ -f ${HOME}/.kops-version ]; then
  mv ${HOME}/.kops-version ${HOME}/.terraform-version.bup
fi
v=$(kopsenv list-remote | head -n 2 | tail -n 1)
echo "${v}" > ${HOME}/.kops-version
(
  kopsenv install || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Installing ${HOME}/.kops-version ${v}"

echo "### Install with parameter and use ~/.kops-version"
v=$(kopsenv list-remote | head -n 1)
(
  kopsenv install ${v} || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Use $HOME/.kops-version ${v}"

echo "### Use with parameter and  ~/.kops-version"
v=$(kopsenv list-remote | head -n 2 | tail -n 1)
(
  kopsenv use ${v} || exit 1
  check_version ${v} || exit 1
) || error_and_proceed "Use $HOME/.kops-version ${v}"

rm $HOME/.kops-version
if [ -f $HOME/.kops-version.bup ]; then
  mv $HOME/.kops-version.bup $HOME/.terraform-version
fi

echo "### Install invalid specific version"
cleanup || error_and_die "Cleanup failed?!"

v=9.9.9
expected_error_message="No versions matching '${v}' found in remote"
[ -z "$(kopsenv install ${v} 2>&1 | grep "${expected_error_message}")" ] \
  && error_and_proceed "Installing invalid version ${v}"

echo "### Install invalid latest:<regex> version"
cleanup || error_and_die "Cleanup failed?!"

v="latest:word"
expected_error_message="No versions matching '${v}' found in remote"
[ -z "$(kopsenv install ${v} 2>&1 | grep "${expected_error_message}")" ] \
  && error_and_proceed "Installing invalid version ${v}"

if [ ${#errors[@]} -gt 0 ]; then
  echo -e "\033[0;31m===== The following install_and_use tests failed =====\033[0;39m" >&2
  for error in "${errors[@]}"; do
    echo -e "\t${error}"
  done
  exit 1
else
  echo -e "\033[0;32mAll install_and_use tests passed.\033[0;39m"
fi;
exit 0
