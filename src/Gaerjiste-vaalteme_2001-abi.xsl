<?xml version="1.0"?>
<!--+
    | Transforms Gaerjiste-vaalteme_2001 (xhtml version via Abiword) to clean
    | xml, containing only the entries and their translations.
    +-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  <xsl:output encoding="UTF-8"/>
  <xsl:output method="xml"/>

  <xsl:template match="html">
    <dictionary>
      <xsl:apply-templates />
    </dictionary>
  </xsl:template>

  <!--xsl:template match="body">
    <xsl:apply-templates select="div[2]"/>
  </xsl:template>

  <xsl:template match="body/div">
    <xsl:apply-templates select="div[3]"/>
  </xsl:template>

  <xsl:template match="div/div">
    <xsl:apply-templates select="p[span]"/>
  </xsl:template>

  <xsl:template match="p[../div]">
    <e>
      <xsl:apply-templates />
    </e>
  </xsl:template-->

</xsl:stylesheet>
