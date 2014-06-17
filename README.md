# BIEPubFont
`BIEPubFont`project can be used to duplicate all `.css` files and replace any specified fonts inside an EPub file. 

[![Build Status](https://travis-ci.org/grigaci/EPubFont.svg?branch=master)](https://travis-ci.org/grigaci/EPubFont)

## Contains
* `BIEPubFontLib` used for modifing the EPub content.
* `BIEPubFont` used as example of the library.

## Requirements

* iOS 7
* Xcode 5

## Installation

Copy the `BIEPubFontLib/`folder.

## Example

### EPub content
* Before

 ![iPhone and iPad Mini screenshots](https://cloud.githubusercontent.com/assets/1185635/3302476/a56e8f4c-f634-11e3-83ce-aefb6b97409e.png)

* After

 ![iPhone and iPad Mini screenshots](https://cloud.githubusercontent.com/assets/1185635/3302526/1f758e8a-f635-11e3-9532-a2c96eb2da55.png)


### CSS file content
* EPUB/css/epub.css

``` css

span.lineannotation {
  font-style: italic;
  color: red;
  font-family: serif, "Free Serif";
}



h1 {
  font-size: 1.5em;
  font-weight: bold;
  font-family: "Free Sans Bold", sans-serif;
  margin-top: 20px !important;
}


body {
  font-family: "Free Serif", serif;
}


```

* EPUB/css/epub-Arial.css

``` css

span.lineannotation {
  font-style: italic;
  color: red;
  font-family: Arial;
}

h1 {
  font-size: 1.5em;
  font-weight: bold;
  font-family: Arial;
  margin-top: 20px !important;
}

body {
  font-family: Arial;
}

```
