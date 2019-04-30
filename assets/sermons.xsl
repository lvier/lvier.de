<?xml version="1.0" encoding="UTF-8" ?>

<!--
    RSS podcast display.

    This stylesheet will render the sermons from an itunes-compatible podcast RSS-feed.
-->

<xsl:stylesheet
        xmlns="http://purl.org/rss/1.0"
        xmlns:xml="http://www.w3.org/XML/1998/namespace"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:content="http://purl.org/rss/1.0/modules/content/"
        xmlns:wfw="http://wellformedweb.org/CommentAPI/"
        xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:media="http://www.rssboard.org/media-rss"
        version="1.0" xmlns:xsd="http://www.w3.org/1999/XSL/Transform"
        xml:lang="en">

    <xsl:output method="html" />

    <xsl:template match="/rss">
        <html>
            <xsl:apply-templates select="channel" />
        </html>
    </xsl:template>

    <xsl:template match="channel">
        <head>
            <title>
                <xsl:value-of select="title" />
            </title>
        </head>
        <body></body>
    </xsl:template>

</xsl:stylesheet>