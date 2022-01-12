#!/usr/bin/env bash

# Runs go build for each of the provided platforms
# The name of the package is the first parameter when calling this script e.g. ./build.sh my-package
package_name=$1
platforms=("windows/amd64" "windows/386" "darwin/amd64" "darwin/arm64" "linux/amd64" "linux/arm64")

for platform in "${platforms[@]}"; do
  platform_split=(${platform//\// })
  GOOS=${platform_split[0]}
  GOARCH=${platform_split[1]}

  output_name=$package_name'-'$GOOS'-'$GOARCH
  file="./build/$output_name"

  if [ $GOOS = "windows" ]; then
    env GOOS=$GOOS GOARCH=$GOARCH go build -o "$file.exe"
    zip "$file.zip" "$file.exe"
    rm "$file.exe"
  else
    env GOOS=$GOOS GOARCH=$GOARCH go build -o $file
    tar -cvzf "$file.tar.gz" $file
    rm $file
  fi

  if [ $? -ne 0 ]; then
      echo An error has occurred while building for $platform
      exit 1
  fi

done
