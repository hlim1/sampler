<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output
    method="html"
    doctype-system="http://www.w3.org/TR/html4/strict.dtd"
    doctype-public="-//W3C//DTD HTML 4.01//EN"/>


  <!-- main master template for generated page -->
  <xsl:template match="/overview">
    <html>
      <head>
	<title>Reports Overview</title>
	<link rel="stylesheet" href="overview.css" type="text/css"/>
      </head>

      <body>
	<!-- generic page header -->
	<h1>Reports Overview</h1>

	<xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


  <!-- main master template for generated page -->
  <xsl:template match="/overview">
    <html>
      <head>
	<title>Reports Overview</title>
	<link rel="stylesheet" href="overview.css" type="text/css"/>
      </head>

      <body>
	<!-- generic page header -->
	<h1>Reports Overview</h1>

	<xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


  <!-- link to one build's summary page -->
  <xsl:template match="result">
    <p>
      <a href="results/{@distribution}/{@application}/summary.xml">
	<xsl:value-of select="@distribution"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="@application"/>
      </a>
    </p>
  </xsl:template>


</xsl:stylesheet>
