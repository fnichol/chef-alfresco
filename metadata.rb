maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Installs Alfresco Community Edition."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

recipe "alfresco", "Installs Alfresco Community Edition."

supports "ubuntu"
supports "el", ">= 6.0"
supports "centos", ">= 6.0"

depends "imagemagick"
depends "java"
depends "mysql"
depends "database"
depends "openoffice"
depends "swftools"
depends "tomcat"
depends "nginx"
depends "maven"
