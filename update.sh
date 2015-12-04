#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do	
  fullVersion="$(curl -fsSL "http://repos.mesosphere.com/ubuntu/dists/trusty/main/binary-amd64/Packages.gz" | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^mesos$/ && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
	(
		set -x
		cp docker-entrypoint.sh "$version/"
		sed '
			s/%%MESOS_MAJOR%%/'"$version"'/g;
			s/%%MESOS_VERSION%%/'"$fullVersion"'/g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
