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
    window.addEventListener('DOMContentLoaded', function() {
        document.getElementById('spinner').classList.remove('hidden');

        // Check if XSLT is supported.
        if (xsltProcessor) {
            try {
                // Load the xslt.
                var request = new XMLHttpRequest();
                request.open("GET", "/assets/sermons.xslt", false);
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

        document.getElementById('spinner').classList.add('hidden');
        if (dom) {
            // Display the list.
            document.getElementById('sermons').append(dom);
        } else if (!xsltProcessor) {
            // Shout at the user for being on IE.
            document.getElementById('unsupported-alert').classList.remove('hidden');
        } else {
            // Generic error message otherwise.
            // TODO This could use some more error handling.
            document.getElementById('fail-alert').classList.remove('hidden');
        }
    });
})();
