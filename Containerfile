FROM --platform=linux/amd64 docker.io/library/tomee:8-jre-7.1.4-plus

# Server-side libraries that GlassFish provides but TomEE does not: Derby (database driver) and
# the EclipseLink JPA provider referenced by persistence.xml.
# tomee-libs/ is populated by:
#   mvn dependency:copy-dependencies -DincludeScope=provided -DoutputDirectory=tomee-libs
#
# Only the jars TomEE needs are copied (rather than copying everything and deleting some):
#   derby-*.jar                          Derby database driver
#   org.eclipse.persistence.[acj]*.jar   EclipseLink antlr, asm, core, jpa and jpa.jpql
#
# The [acj] glob deliberately skips org.eclipse.persistence.moxy. Also left out on purpose are
# jersey-*, hk2-*, osgi-resource-locator, asm-all-repackaged, cglib and guava: a Jersey
# ResourceConfig on the server classpath makes TomEE deploy a root-mapped JAX-RS application
# that answers 404 for /javax.faces.resource/* (breaks PrimeFaces/JSF scripts). TomEE's CXF
# handles JAX-RS and the JAX-RS client instead.
# If a new EclipseLink jar is needed whose name starts with another letter, extend the [acj] class.
COPY tomee-libs/derby-*.jar tomee-libs/org.eclipse.persistence.[acj]*.jar /usr/local/tomee/lib/

# JMS connection factory (DefaultJMSConnectionFactory) used by the app's @Inject JMSContext.
COPY tomee-conf/tomee.xml /usr/local/tomee/conf/tomee.xml
COPY tomee-conf/system.properties /usr/local/tomee/conf/system.properties

ENV CATALINA_OPTS="-Dorg.apache.activemq.SERIALIZABLE_PACKAGES=*"

COPY target/cargo-tracker.war /usr/local/tomee/webapps/cargo-tracker.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
