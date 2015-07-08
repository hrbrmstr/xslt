#' Transform an XML document with an XSLT stylesheet
#'
#' @param xml_doc an XML or HTML document (either a string with XML/HTML, a filename
#'        or URL pointing to a file wiht XML/HTML). This can also be the result
#'        of a value returned from \code{xml2::read_xml} or \code{xml2::read_html}, thus
#'        enabling it to be used in pipelines.
#' @param xslt_doc an XSLT document (either a string with XML/XSLT, a filename
#'        or URL pointing to a file wiht XML/XSLT). This can also be the result
#'        of a value returned from \code{xml2::read_xml} or \code{xml2::read_html}.
#' @param is_html is \code{xml_doc} really an HTML? If so, set this (default \code{FALSE})
#' @param fix_ns intercourse the namespaces (highly useful for HTML processing - default \code{FALSE})
#' @return Either objects comparable to \code{xml2::read_xml} or \code{xml2::read_html} (if the
#'         XSLT output method was \code{xml} or \code{html} respectively) or a single-element
#'         character vector with the transformed document text.
#' @import rvest
#' @import xml2
#' @importFrom stringr str_replace str_count
#' @export
#' @examples
#' library(xml2)
#' library(xslt)
#'
#' xml_src <- "<test/>"
#' xslt_src <- '<xsl:stylesheet version="1.0"
#'   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
#'
#'   <xsl:template match="/">
#'     <article>
#'       <title>Hello World</title>
#'     </article>
#'   </xsl:template>
#' </xsl:stylesheet>'
#'
#' doc <- read_xml(xml_src)
#' xsl <- read_xslt(xslt_src)
#'
#' res <- xslt_transform(doc, xsl)
#' cat(as.character(res))
#'
#' res <- xslt_transform(xslt_src, xslt_src)
#' cat(as.character(res))
xslt_transform <- function(xml_doc, xslt_doc,
                       is_html=FALSE, fix_ns=FALSE) {


  if (inherits(xml_doc, c("xml_document", "xml_node"))) {
    xml_doc <- as.character(xml_doc)
  } else {
    if (is_html) {
      xml_doc <- as.character(read_html(xml_doc))
    } else {
      xml_doc <- as.character(read_xml(xml_doc))
    }
  }

  if (inherits(xslt_doc, c("xml_document", "xml_node"))) {
    xslt_doc <- as.character(xslt_doc)
  } else {
    xslt_doc <- as.character(read_xslt(xslt_doc))
  }

  if (fix_ns) { # bloody xmlns
    i <- 1
    while (str_count(xml_doc, "xmlns") != 0) {
      doc <- str_replace(xml_doc, "xmlns[:]*", sprintf("XMLNSISEVIL%d", i))
      i <- i + 1
    }
  }

  res <- .xslt_transform(xslt_doc, xml_doc)

  xslt_doc <- read_xslt(xslt_doc)
  ns <- xml_ns_rename(xml_ns(xslt_doc), xsl = "xsl")
  out <- tryCatch(xml_attr(xml_find_one(xslt_doc, "xsl:output", ns), "method"),
                  error=function(err) { "xml" },
                  finally=function(err) { "xml" })

  if (is.na(out) | out == "xml") {
    read_xml(res)
  } else if (out == "html") {
    read_html(res)
  } else if (out == "text") {
    res
  } else {
    read_xml(res)
  }

}

#' Read in an XSLT document
#'
#' Lightweight wrapper for read_xml
#'
#' @param xslt_src an XSLT document (either a string with XML/XSLT, a filename
#'        or URL pointing to a file wiht XML/XSLT)
#' @return This has the same return value as \code{xml2::read_xml} but adds
#'        \code{xslt_document} to the class list for potential future use with
#'        this package.
#' @export
#' @examples
#' library(xslt)
#'
#' xslt_src <- '<xsl:stylesheet version="1.0"
#'   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
#'
#'   <xsl:template match="/">
#'     <article>
#'       <title>Hello World</title>
#'     </article>
#'   </xsl:template>
#' </xsl:stylesheet>'
#'
#' xsl <- read_xslt(xslt_src)
#' (class(xsl))
read_xslt <- function(xslt_src) {
  tmp <- read_xml(xslt_src)
  class(tmp) <- c("xslt_document", class(tmp))
  return(tmp)
}
