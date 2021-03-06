# Generating Raster Tiles from Vector Map Data

This project was forked from [CMU-CREATE-Lab/tile-generation](https://github.com/CMU-CREATE-Lab/tile-generation). Credits to the awesome guys of CMU-CREATE-Lab and OpenMapTiles/Klokantech technologies. 

This project contains a collection of tools--with documentation--for generating raster map tiles from vector map data and a Mapbox GL style.

The toolchain consists of [Maputnik](https://github.com/maputnik/editor) for creating/editing Mapbox GL styles, [Tileserver GL](https://openmaptiles.org/docs/host/tileserver-gl/) to apply the style(s) to [vector map data](https://openmaptiles.com/downloads/planet/) and serve up raster tiles, and a custom script to scrape and save the tiles as PNGs.

## How to Generate Tiles

Here's everything you'll need to do to generate tiles.  This project is great for everyone who is struggling to find the right stack to pre-generate raster tiles from vector map data. See discussion here: https://gis.stackexchange.com/questions/252338/render-raster-tiles-from-a-mapbox-gl-style?rq=1. In summary, with this project there is no need anymore for CartoCSS or Mapnik XML, but styling can be done with Mapbox GL styles, while also having the ability to pre-generate old-fashioned raster tiles for hosting them elsewhere on the web. 

### Tileserver GL

First, you'll need Tileserver GL installed.  There are at least a couple ways to install, but using Docker is the easiest.

#### Installing with Docker

Following the instructions at [https://openmaptiles.org/docs/host/tileserver-gl/](https://openmaptiles.org/docs/host/tileserver-gl/), tileserver-gl can be installed by doing this:

	docker pull klokantech/tileserver-gl:v2.4.0

I used v2.4.0 here due to problems with labels cuting off at tiles edges while rendering raster tiles on later versions of tileserver-gl. Seems to be a problem with mapbox-native-gl since realease v2.5. For vector tiles no issues. 

#### Other Required Pieces

Before trying to run it, you'll need to download some required bits, just because they're too big to put in this project.

##### Map Data

You'll need vector map data. Fortunaly, we have the awesome OpenMapTiles and OpenStreetMap contributors! If you want vector map data for the whole planet, you'd better have both time and disk space...it's ~51 GB. Initial tests with two different datasets: the United States and Great Britain were done by [CMU-CREATE-Lab/tile-generation](https://github.com/CMU-CREATE-Lab/tile-generation). In this project, tests were done with The Netherlands. All datasets are large, 6.7GB, 1.2GB and 954,6 MB respectively, so they're not included here.  You'll need to download the .mbtiles archives from OpenMapTiles here:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Whole Planet<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://openmaptiles.com/downloads/planet/

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;United States<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://openmaptiles.com/downloads/north-america/us/

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Great Britain<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://openmaptiles.com/downloads/europe/great-britain/

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The Netherlands<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://openmaptiles.com/downloads/europe/netherlands/

Just save them into the `tileserver-gl/mbtiles` directory in this project.

##### Fonts

The styles we're using require some fonts.  Note that I'm using v1.1, because v2 changes the name of some fonts, but the styles below haven't been updated accordingly (yet?).  Anyway, you can download the zip from here:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/openmaptiles/fonts/releases/tag/v1.1

Extract the zip into a directory named `fonts` located under the `tileserver-gl` directory in this project.

##### Styles

I've already downloaded and included some styles in the project, but here's where they can be found.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Klokantech Basic v1.3<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/openmaptiles/klokantech-basic-gl-style/releases

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OSM Bright v1.3<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/openmaptiles/osm-bright-gl-style/releases

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Positron v1.4<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/openmaptiles/positron-gl-style/releases

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dark Matter v1.3<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/openmaptiles/dark-matter-gl-style/releases

I've also included some styles of my own based on some of the above and based on the styles added by [CMU-CREATE-Lab/tile-generation](https://github.com/CMU-CREATE-Lab/tile-generation). My custom styles are positron-simplified-labels, positron-no-labels, klokantech-basic-cpb-simplified-labels. These styles were made for generating great basemaps for the Netherlands. Note that place name labels have been optimized for use with the map extent of the Netherlands. In the default styles random cities were displaying at low zoom level and in my opinion there were just too many labels. Less is more sometimes. 

The bounds used for the Netherlands: 3.0847 (left/min Longitude/west/minX), 50.7395 (bottom/min Latitude/south/minY), 7.2693 (right/max Longitude/east/MaxX), 53.7355 (top/max Latitude/north/MaxY).

The bounds used for the ABC islands: 70.399 (left/min Longitude/west/minX), 12.0002 (bottom/min Latitude/south/minY), -68.0019 (right/max Longitude/east/MaxX), 12.9923 (top/max Latitude/north/MaxY). 

##### Config

There are five tileserver-gl configuration files for the styles included here plus the map data and fonts you downloaded above:
    
    tileserver-gl-config-planet.json
    tileserver-gl-config-north-america_us.json
    tileserver-gl-config-europe_great-britain.json
    tileserver-gl-config-europe_the_netherlands.json
    tileserver-gl-config-abceilanden.json
  
If the mbtiles files you downloaded have filenames different than what's referenced in the above JSON config files, you'll need to fix the config file(s) accordingly. So please take a look at the bounding box and paths to the config files.

For this project the tileserver-gl-config-europe_the_netherlands.json config file was used to generate tiles for the Netherlands. 

#### Running Tileserver GL

Now that all the pieces are in place, you should be able to run tileserver-gl and explore the map data with each of the various styles.  Open a terminal window and `cd` to the `tileserver-gl` directory of this project and run one of these commands, depending on which data set you want to view:

    docker run --rm -it -v $(pwd):/createlab -p 8080:80 klokantech/tileserver-gl:v2.4.0 --config /createlab/tileserver-gl-config-planet.json

or

    docker run --rm -it -v $(pwd):/createlab -p 8080:80 klokantech/tileserver-gl:v2.4.0 --config /createlab/tileserver-gl-config-north-america_us.json

or

    docker run --rm -it -v $(pwd):/createlab -p 8080:80 klokantech/tileserver-gl:v2.4.0 --config /createlab/tileserver-gl-config-europe_great-britain.json

or

    docker run --rm -it -v $(pwd):/createlab -p 8080:80 klokantech/tileserver-gl:v2.4.0 --config /createlab/tileserver-gl-config-europe_the_netherlands.json

or

    docker run --rm -it -v $(pwd):/createlab -p 8080:80 klokantech/tileserver-gl:v2.4.0 --config /createlab/tileserver-gl-config-abceilanden.json

   
Brief description of some of the parts of those commands:
* `-v $(pwd):/createlab` Mounts a volume in Docker named `/createlab` and binds it to the current directory.  This lets us reference files in the Mac OS filesystem from tileserver-gl. Notice the various paths in the tileserver-gl config files which start with `/createlab`
* `-p 8080:80` Maps port 8080 on the Mac to port 80 in Docker.  
* `--config /createlab/*.json` Tells tileserver-gl where to find the config file

Once it's running, test it out by opening a browser and going to [http://localhost:8080/](http://localhost:8080/).

### Maputnik

Maputnik is a really nice, browser-based editor for Mapbox GL styles. If you're happy with the styles included here, you can skip this entire section and just jump down to the **Generating Tiles** section below.

You can install Maputnik: https://github.com/maputnik/editor

However, save yourself some time and use the online editor in the browser (recommended):
https://maputnik.github.io/
https://editor.openmaptiles.org/

#### Slight Wrinkle

The only wrinkle is that the style file has URLs for where it can find vector map data, sprites, and fonts ("glyphs").  I have two for Maputnik, and a slightly different one for Tileserver GL.  If you compare these files...

```
tileserver-gl/styles/osm-bright-cpb-gl-style/maputnik-style-local.json
tileserver-gl/styles/osm-bright-cpb-gl-style/maputnik-style-remote.json
tileserver-gl/styles/osm-bright-cpb-gl-style/style-local.json
```
...you'll see those three fields differ as shown below:

**maputnik-style-local.json**
```json
  "sources": {
    "openmaptiles": {
      "type": "vector",
      "url": "http://localhost:8080/data/v3.json"
    }
  },
  "sprite": "http://localhost:8080/styles/osm-bright-cpb/sprite",
  "glyphs": "http://localhost:8080/fonts/{fontstack}/{range}.pbf",
``` 

**maputnik-style-remote.json**
```json
  "sources": {
    "openmaptiles": {
      "type": "vector",
      "url": "https://free.tilehosting.com/data/v3.json?key={key}"
    }
  },
  "sprite": "https://openmaptiles.github.io/osm-bright-gl-style/sprite",
  "glyphs": "https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf?key={key}",
``` 

**style-local.json**
```json
  "sources": {
    "openmaptiles": {
      "type": "vector",
      "url": "mbtiles://{v3}"
    }
  },
  "sprite": "{styleJsonFolder}/sprite",
  "glyphs": "{fontstack}/{range}.pbf",
``` 

The difference between the two maputnik style files is that `maputnik-style-local.json` is configured to get all vector data tiles, sprites, and fonts locally, from Tileserver GL.  And thus you'll need to have Tileserver GL running for Maputnik to be able to work and edit that style file, and you'll also need the vector map data to be local.  The `maputnik-style-remote.json` file is configured to pull all vector data tiles, sprites, and fonts from the cloud.  I prefer the local one since I like the style I'm editing to be using the exact same assets that the tile generation will be using.

Finally, the `style-local.json` is just for Tileserver GL (and is referenced in the various `tileserver-gl-config-*.json` files).

The most important thing to remember is that, once you get the style working how you want it--regardless of whether you're using the local or remote maputnik style file--you *must* apply those changes to the other two style files.  And be sure to also fire up Tileserver GL to check your work.  I've seen cases where Maputnik and Tileserver GL interpret the style JSON differently.

If you make changes, don't forget to apply them (but not the three URLs shown above!) to `style-local.json`.

#### The Style Editing and Verification Process

Here's what to do to edit a style:
1. Use Maputnik, pointed at the maputnik version of the style you want to edit. The "maputnik version" just means those three URLs are pointing to the cloud rather than local. In this repo, that's the `maputnik-style-local.json` file.
2. Copy style changes to the tileserver-gl version of the style. In this repo, that's the `style-local.json` file.
3. Run tileserver-gl, and verify that your style looks good with the vector map data you have.

### Generating and Fetching Tiles

At long last, we can finally generate and fetch the tiles... (this part is great!)

The script in the `tile-fetcher` directory fetches all tiles for a given level and lat/long bounding box directly from Tileserver GL.  It's a Node.js script, with Node.js 8.9.2, but it might work for other versions.  

#### Installation

Do this to install dependencies:

```
$ cd tile-fetcher
$ npm install
```

#### Options

You specify the bounding box, levels, style, etc. through command line arguments to the script.  Do `node index.js --help` to see the options.  Here are the required options:

| Option | Description |
|--------|-------------|
|`--style  <Style name>`|The map style name, as it appears in the Tileserver GL tile URL, e.g. `klokantech-basic-cpb`.|
|`--level  <Zoom level(s)>`|Zoom level(s) to fetch.  Must be in the range [0,16]. Specify multiple levels as a comma-delimited list, a range, or a combination of the two.|
|`--dir    <Output directory> `|Directory in which tiles will be saved.|


Here are the optional options:

| Option | Description |
|--------|-------------|
|`--west   <West longitude>   `|The west longitude of the bounding box to fetch. Defaults to `-180` if unspecified.|
|`--east   <East longitude>   `|The east longitude of the bounding box to fetch. Defaults to `179.9999999999999` if unspecified.|
|`--north  <North latitude>   `|The north latitude of the bounding box to fetch. Defaults to `85.0511` if unspecified.|
|`--south  <South latitude>   `|The south latitude of the bounding box to fetch. Defaults to `-85.0511` if unspecified.|
|`--n      <Num tile fetchers>`|Number of tile fetchers to use. Defaults to `6` if unspecified.|
|`--host   <Tile server host> `|Host name of the tile server. Defaults to `localhost` if unspecified.|
|`--port   <Tile server port> `|Port number of the tile server. Defaults to `8080` if unspecified.|
|`--start  <x,y>              `|Start at the tile specified by the given x and y. This option is ignored if more than one level is specified.|
|`--retina                    `|Fetch retina tiles|
|`--dry-run                   `|Don't actually fetch tiles, just compute what tiles would be fetched and print the results.|

#### Running

Here's an example for generating and fetching levels 0-8 for the entire Earth using the `klokantech-basic-cpb` style (this is assuming you have Tileserver GL running with the `tileserver-gl-config-planet.json` and listening on port 8080, as shown above):

```
$ node index.js --style klokantech-basic-cpb  --dir ./tiles/klokantech-basic-cpb --level 0-8
```

This will fetch retina tiles for levels 1-4 and levels 7 and 9 for the United States using the `dark-matter-cpb` style, assuming Tileserver GL is listening on port 8081:

```
$ node index.js --style dark-matter-cpb  --dir ./tiles/dark-matter-cpb@2x --level 1-4,7,9 --port 8081 --west -125.3321 --east -65.7421 --south 23.8991 --north 49.4325 --retina
```

For zoom levels having more than 20 tiles, you'll get a progress report approximately every 5%.

Since Tileserver GL seems to crash on me fairly often when I'm running multiple instances, it's handy to be able to start tile fetches somewhere in the middle of a level so I can resume where it crashed. You can optionally specify the starting tile by providing the `--start` option, e.g. to start at tile with x=10 and y=32:

```
$ node index.js --style klokantech-basic-cpb  --dir ./tiles/klokantech-basic-cpb --level 6 --start 10,32
```

The above command would fetch only 2038 of the 4096 tiles in level 6.

Note that the starting tile option is only honored when requesting a single level.

#### Generating tiles for the Netherlands

Here an example of how to make a tiled basemap for the Netherlands (if you have tileserver-gl listening on port 8080 with the tileserver-gl-config-europe_the_netherlands.json config file). The command below generates and fetches levels 0-8 for the entire Earth, and levels 9-14 for the bounding box of the Netherlands, using the `positron-simplified-labels` style.

```
cd ~/tile-generation/tile-fetcher/
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 0-8 
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 9-14 --west 3.0847 --east 7.2693 --south 50.7395 --north 53.7355
```

#### Generating tiles for the Aruba, Bonaire, Curacao (ABC-eilanden)

Here an example of how to make a tiled basemap for the ABC islands (if you have tileserver-gl listening on port 8080 with the tileserver-gl-config-abceilanden.json config file). The command below generates and fetches levels 0-8 for the entire Earth, and levels 9-14 for the bounding box of the ABC islands, using the `positron-simplified-labels` style. 

```
cd ~/tile-generation/tile-fetcher/
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 0-8 
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 9-14 --west -70.3997 --east -68.0019 --south 12.0002 --north 12.9923
```
Please note that you would first need mbtiles of the custom extract of the ABC-islands. 

```
npm install -g tilelive mbtiles
```
```
tilelive-copy --minzoom=0 --maxzoom=14 --bounds="-70.3997,12.0002, -68.0019, 12.9923" tile-generation/tileserver-gl/mbtiles/planet.mbtiles tile-generation/tileserver-gl/mbtiles/abceilanden.mbtiles
```
More info on https://openmaptiles.org/docs/generate/create-custom-extract/.

#### Generating tiles for BES islands (BES-eilanden)

Here an example of how to make a tiled basemap for the BES islands (if you have tileserver-gl listening on port 8080 with the tileserver-gl-config-abceilanden.json config file). The command below generates and fetches levels 0-8 for the entire Earth, and levels 9-14 for the bounding box of the BES islands, using the `positron-simplified-labels` style.

```
cd ~/tile-generation/tile-fetcher/
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 0-8 
node index.js --style positron-simplified-labels  --dir ./tiles/positron-simplified-labels --level 9-14 --west -63.5967 --east -62.4047 --south 17.0072 --north 18.3933
```
Please note that you would first need mbtiles of the custom extract of the BES-islands. 

```
npm install -g tilelive mbtiles
```
```
tilelive-copy --minzoom=0 --maxzoom=14 --bounds="-63.5967, 17.0072, -68.0019, 18.3933" tile-generation/tileserver-gl/mbtiles/planet.mbtiles tile-generation/tileserver-gl/mbtiles/abceilanden.mbtiles
```
More info on https://openmaptiles.org/docs/generate/create-custom-extract/. 

#### Viewing Tiles

Once you have some tiles generated and fetched, you can preview them using the `tile-viewer.html` file (also in the `tile-fetcher` directory). I've modified this leaflet tile viewer for my own use, so you may need to edit according to where you saved your tiles.



