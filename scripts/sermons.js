/*
 * Sermons page.
 *
 * This script implements functionality to quickly list and download sermons.
 */

/*
 * Initial setup.
 */
(function() {
    "use strict";

    var xsltStylesheet;
    var xsltProcessor = window.XSLTProcessor && new XSLTProcessor() || null;
    var xmlDoc;
    var dom;

    /*
     * Main script.
     */
    $(document).ready(function() {

        // Check if XSLT is supported.
        if (xsltProcessor) {
            try {
                // Load the xslt.
                var request = new XMLHttpRequest();
                request.open("GET", "/assets/sermons.xsl", false);
                request.send(null);

                xsltStylesheet = request.responseXML;
                xsltProcessor.importStylesheet(xsltStylesheet);

                // Load the xml.
                request = new XMLHttpRequest();
                request.open("GET", "/predigten?format=rss", false);
                request.send(null);

                xmlDoc = request.responseXML;

                var fragment = xsltProcessor.transformToFragment(xmlDoc, document);
            }
            catch (e) {
                // This should usually be a bad internet connection.
                console.error(e);
            }

            dom = fragment;
        }

        $("#spinner").remove();
        if (dom) {
            // Display the list.
            $("#sermons").empty().append(dom);
        } else if (!xsltProcessor) {
            // Shout at the user for being on IE.
            $("#unsupported-alert").removeClass('hidden');
        } else {
            // Generic error message otherwise.
            // TODO This could use some more error handling.
            $("#fail-alert").removeClass('hidden');
        }
    });
})();
