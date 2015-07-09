<!-- README.md is generated from README.Rmd. Please edit that file -->
![logo](logo.png)

### Transform XML Documents with XSLT Stylesheets in R

The following functions are implemented:

-   `xslt_transform`: Transform an XML document with an XSLT stylesheet
-   `read_xslt`: Read in an XSLT document

You will need `libxml2`, `libxslt`, `lxsltwrapp` and `lxmlwrapp` installed. The first two are very `apt-get`table or `brew install`able (and `yum`mable). The latter two are best installed from [<http://vslavik.github.io/xmlwrapp/>](http://vslavik.github.io/xmlwrapp/), and will eventually be included with the package as it matures. `xmlwrapp` is extremely lightweight and compiles well on linux and Mac OS X. There's a `cygwin` port [here](https://github.com/fd00/yacp/tree/master/xmlwrapp) that may be of use on Window.

The package has been designed to work nicely with `xml2` workflows as it accepts objects from `xm2::read_xml` and `xml2::read_html` and returns similar objects (if the XSLT output method is `xml` or `html`).

Unlike [Sxslt](http://www.omegahat.org/Sxslt/) and [SXalan](http://www.omegahat.org/SXalan/) (both pretty much defunct with some fairly easy-to-generate memory bugs), `xslt` provides one real function: the ability to use XSLT stylesheets in XML processing workflows. This was born out of the desire to use XSLT transformations to extract just the salient text from scraped web sites, similar to the way [readability](https://github.com/masukomi/ar90-readability) works (but more for just clean text extraction versus making the text actually human readable and "pretty").

### News

See [CHANGELOG](CHANGELOG.md)

### Installation

``` r
devtools::install_github("hrbrmstr/xslt")
```

### Usage

``` r
library(xslt)

# current verison
packageVersion("xslt")
#> [1] '0.0.0.9001'
```

### Test Results

``` r
library(xslt)
library(testthat)
library(xml2)

date()
#> [1] "Wed Jul  8 22:52:43 2015"

xml_src <- "<test/>"
xslt_src <- '<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <article>
      <title>Hello World</title>
    </article>
  </xsl:template>
</xsl:stylesheet>'

doc <- read_xml(xml_src)
xsl <- read_xslt(xslt_src)

res <- xslt_transform(doc, xsl)
cat(as.character(res))
#> <?xml version="1.0" encoding="UTF-8"?>
#> <article><title>Hello World</title></article>


test_dir("tests/")
#> basic functionality :
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
