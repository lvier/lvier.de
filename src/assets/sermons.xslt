<?xml version="1.0" encoding="UTF-8" ?>

<!--
    RSS podcast display.

    This stylesheet will render the sermons from an itunes-compatible podcast RSS-feed.

    FIXME The XPaths can't be checked, because squarespace doesn't put the rss-elements in a namespace.
-->

<!--suppress XmlUnusedNamespaceDeclaration -->
<xsl:stylesheet
        xmlns="http://www.rssboard.org/rss-specification"
        xmlns:xml="http://www.w3.org/XML/1998/namespace"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
        xmlns:media="http://www.rssboard.org/media-rss"
        xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
        xmlns:content="http://purl.org/rss/1.0/modules/content/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:wfw="http://wellformedweb.org/CommentAPI/"
        xsi:schemaLocation="
            http://www.rssboard.org/rss-specification http://www.lvier.de/assets/rss.xsd
            http://www.w3.org/XML/1998/namespace http://www.w3.org/2001/xml.xsd
            http://www.w3.org/2001/XMLSchema-instance http://www.w3.org/2001/XMLSchema-instance.xsd
            http://www.w3.org/1999/XSL/Transform http://www.lvier.de/assets/xslt.xsd
            http://www.itunes.com/dtds/podcast-1.0.dtd http://www.lvier.de/assets/itunes.xsd
            http://www.rssboard.org/media-rss http://www.lvier.de/assets/media.xsd
            http://purl.org/rss/1.0/modules/syndication/ http://www.lvier.de/assets/syndication.xsd
            http://purl.org/rss/1.0/modules/content/ http://www.lvier.de/assets/content.xsd
            http://purl.org/dc/elements/1.1/ https://www.dublincore.org/schemas/xmls/simpledc20021212.xsd"
        xml:lang="de"
        version="1.0">

    <xsl:output method="html"/>

    <!-- noinspection CheckNodeTest -->
    <xsl:template match="/rss">
        <html>
            <!-- noinspection CheckNodeTest -->
            <xsl:apply-templates select="channel"/>
        </html>
    </xsl:template>

    <!-- noinspection CheckNodeTest -->
    <xsl:template match="channel">
        <head>
            <title>
                <!-- noinspection CheckNodeTest -->
                <xsl:value-of select="title"/>
            </title>
        </head>
        <body>
            <!-- noinspection CheckNodeTest -->
            <xsl:apply-templates select="item"/>
        </body>
    </xsl:template>

    <!-- noinspection CheckNodeTest -->
    <xsl:template match="item">
        <xsl:if test="media:content">
            <a>
                <xsl:attribute name="href">
                    <!-- noinspection CheckNodeTest -->
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <h2>
                    <!-- Parse the filename out of the date, since pubDate is in some crazy american format -->
                    <xsl:call-template name="format-date">
                        <xsl:with-param
                                name="date"
                                select="substring(media:content/@url, string-length(media:content/@url) - 13, 10)"/>
                        <!-- noinspection CheckNodeTest -->
                        <xsl:with-param name="fallback" select="pubDate"/>
                    </xsl:call-template>
                </h2>
            </a>
            <details>
                <summary>Predigttext</summary>
                <!-- noinspection CheckNodeTest -->
                <xsl:value-of select="description" disable-output-escaping="yes"/>
            </details>
            <div>
                <xsl:attribute name="class">sqs-audio-embed</xsl:attribute>
                <xsl:attribute name="data-url">
                    <xsl:value-of select="media:content/@url"/>
                </xsl:attribute>
                <xsl:attribute name="data-mime-type">
                    <xsl:value-of select="media:content/@type"/>
                </xsl:attribute>
                <xsl:attribute name="data-title">
                    <!-- noinspection CheckNodeTest -->
                    <xsl:value-of select="title"/>
                </xsl:attribute>
                <xsl:attribute name="data-author">
                    <xsl:value-of select="itunes:author"/>
                </xsl:attribute>
                <xsl:attribute name="data-show-download">true</xsl:attribute>
                <xsl:attribute name="data-design-style">minimal</xsl:attribute>
                <xsl:attribute name="data-duration-in-ms">
                    <xsl:call-template name="duration-in-ms">
                        <xsl:with-param name="duration" select="itunes:duration"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="data-color-theme">light</xsl:attribute>
            </div>
            <xsl:if test="position() != last()">
                <hr/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="format-date">
        <xsl:param name="date"/>
        <xsl:param name="fallback"/>
        <xsl:variable name="day" select="number(substring($date, 9, 2))"/>
        <xsl:variable name="month" select="number(substring($date, 6, 2))"/>
        <xsl:variable name="year" select="number(substring($date, 1, 4))"/>
        <xsl:choose>
            <!-- Sanity check: NaN != NaN, so if this passes, we are likely to have actually parsed a date. -->
            <xsl:when test="$day = $day and $month = $month and $year = $year and $month &gt; 0 and $month &lt; 13">
                <xsl:variable name="month-name">
                    <xsl:call-template name="month-name">
                        <xsl:with-param name="month" select="$month"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($day, '. ', $month-name, ' ', $year)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fallback"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="month-name">
        <xsl:param name="month"/>
        <xsl:if test="$month = 1">Januar</xsl:if>
        <xsl:if test="$month = 2">Februar</xsl:if>
        <xsl:if test="$month = 3">März</xsl:if>
        <xsl:if test="$month = 4">April</xsl:if>
        <xsl:if test="$month = 5">Mai</xsl:if>
        <xsl:if test="$month = 6">Juni</xsl:if>
        <xsl:if test="$month = 7">Juli</xsl:if>
        <xsl:if test="$month = 8">August</xsl:if>
        <xsl:if test="$month = 9">September</xsl:if>
        <xsl:if test="$month = 10">Oktober</xsl:if>
        <xsl:if test="$month = 11">November</xsl:if>
        <xsl:if test="$month = 12">Dezember</xsl:if>
    </xsl:template>

    <xsl:template name="duration-in-ms">
        <xsl:param name="duration"/>
        <xsl:variable name="hours" select="substring($duration, 1, 2)"/>
        <xsl:variable name="minutes" select="substring($duration, 4, 2)"/>
        <xsl:variable name="seconds" select="substring($duration, 7, 2)"/>
        <xsl:variable name="duration-in-s" select="$hours * 3600 + $minutes * 60 + number($seconds)"/>
        <xsl:value-of select="$duration-in-s * 1000"/>
    </xsl:template>

</xsl:stylesheet>