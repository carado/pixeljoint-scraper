a scraper for [pixeljoint](https://pixeljoint.com/) artists.

### Usage

run `./get.sh` in a directory containing a file called `list`, containing the urls of pixeljoint artists, one per line:

```
https://pixeljoint.com/p/38285.htm
https://pixeljoint.com/p/64720.htm
https://pixeljoint.com/p/46633.htm
https://pixeljoint.com/p/6741.htm
https://pixeljoint.com/p/67002.htm
https://pixeljoint.com/p/45404.htm
https://pixeljoint.com/p/3240.htm
https://pixeljoint.com/p/4343.htm
```

this will create one directory per artist, and in those images will be downloaded.

it is meant to be re-ran periodically to get new images.

