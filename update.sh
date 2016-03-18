#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do
	repoPackage="http://repos.mesosphere.com/ubuntu/dists/trusty/main/binary-amd64/Packages.gz"
  fullVersion="$(curl -fsSL "${repoPackage}" | gunzip | awk -v pkgname="mesos" -F ': ' '$1 == "Package" { pkg = $2 } pkg == pkgname && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
	(
		set -x
		cp docker-entrypoint.sh "$version/"
		sed '
			s/%%MESOS_MAJOR%%/'"$version"'/g;
			s/%%MESOS_RELEASE%%/'"$fullVersion"'/g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
