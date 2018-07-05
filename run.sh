#!/bin/bash

cd ~/tile-generation/tileserver-gl
mkdir -p fonts
chmod -R 777 ~/tile-generation/tileserver-gl/fonts/
cd ~/tile-generation/tileserver-gl/fonts/

wget https://github.com/openmaptiles/fonts/releases/download/v1.1/v1.1.zip
unzip v1.1.zip 
find \( -type f -iname "*.zip" -o -iname "*.tgz" \) -delete

docker pull klokantech/tileserver-gl

docker run --rm -it -v ~/tile-generation/tileserver-gl/:/createlab -p 8080:80 klokantech/tileserver-gl --config /createlab/tileserver-gl-config-europe_the_netherlands.json

cd ~/tile-generation/tile-fetcher/
npm install
node index.js --style positron-no-labels  --dir ./tiles/positron-nl-no-labels --level 0-8




