#include <Rcpp.h>
#include <xmlwrapp/xmlwrapp.h>
#include <xsltwrapp/xsltwrapp.h>

using namespace Rcpp;

// XSLT transform a document
// @param xslt_doc xslt string
// @param xml_doc xml string
// @param process_includes whether or not the XSLT engine will process
//        XInclusions by default while parsing the stylesheet
// @param load_external_subsets whether or not the XML parser should load
//        external (DTD) subsets while parsing
// @param validate_xml whether or not the XML parser should validate every
//        XML document that is parses with its DTD
//[[Rcpp::export(name = ".xslt_transform")]]
std::string xslt_transform(std::string xslt_doc,
                           std::string xml_doc,
                           bool process_includes=false,
                           bool load_external_subsets=false,
                           bool validate_xml=false) {

  // setup parser parameters

  xslt::init::process_xincludes(process_includes);
  xslt::init::load_external_subsets(load_external_subsets);
  xslt::init::validate_xml(validate_xml);

  // load stylesheet and XML document

  xml::document loaded_sheet(xslt_doc.c_str(), xslt_doc.size());
  xml::document loaded_doc(xml_doc.c_str(), xml_doc.size());
  xslt::stylesheet style(loaded_sheet);

  // apply the stylesheeet

  xml::document result;
  xml::error_messages errors;

  style.apply(loaded_doc, result, errors);

  // return result

  std::string ret_val;
  result.save_to_string(ret_val);

  return(ret_val);

}
