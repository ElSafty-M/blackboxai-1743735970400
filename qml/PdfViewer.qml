import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10

Item {
    id: pdfViewer
    property string currentPdf: ""
    property var searchResults: []

    WebEngineView {
        id: webView
        anchors.fill: parent
        settings.javascriptEnabled: true
        settings.localContentCanAccessRemoteUrls: true
        settings.pluginsEnabled: true

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                highlightSearchTerms()
            }
        }
    }

    function loadPdf(path) {
        currentPdf = path
        webView.url = "file://" + path
    }

    function highlightSearchTerms() {
        if (searchResults.length > 0) {
            let script = `
                var searchTerms = ${JSON.stringify(searchResults)};
                var spans = document.querySelectorAll('span.highlight');
                spans.forEach(span => {
                    span.outerHTML = span.innerHTML;
                });
                searchTerms.forEach(term => {
                    var body = document.body.innerHTML;
                    var re = new RegExp(term, 'gi');
                    document.body.innerHTML = body.replace(re, 
                        '<span class="highlight" style="background-color: yellow;">$&</span>');
                });
            `
            webView.runJavaScript(script)
        }
    }

    function clearHighlights() {
        webView.runJavaScript(`
            var spans = document.querySelectorAll('span.highlight');
            spans.forEach(span => {
                span.outerHTML = span.innerHTML;
            });
        `)
    }

    Connections {
        target: pythonBridge
        function onSearchResultsReady(paths) {
            searchResults = paths
            if (currentPdf !== "") {
                highlightSearchTerms()
            }
        }
    }
}