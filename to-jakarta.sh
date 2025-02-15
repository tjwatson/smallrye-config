#!/usr/bin/env bash

# move to jakarta parent
find . -type f -name 'pom.xml' -exec sed -i '' 's/smallrye-parent/smallrye-jakarta-parent/g' {} +
# java sources
find . -type f -name '*.java' -exec sed -i '' 's/javax./jakarta./g' {} +
# service loader files
find . -path "*/src/main/resources/META-INF/services/javax*" | sed -e 'p;s/javax/jakarta/g' | xargs -n2 git mv
# docs
find doc -type f -name '*.adoc' -exec sed -i '' 's/javax./jakarta./g' {} +

mvn build-helper:parse-version versions:set -DnewVersion=\${parsedVersion.nextMajorVersion}.0.0-SNAPSHOT
find examples -depth 1 -type d | xargs -I{} mvn -pl {} build-helper:parse-version versions:set -DnewVersion=\${parsedVersion.nextMajorVersion}.0.0-SNAPSHOT

mvn versions:update-property -Dproperty=version.eclipse.microprofile.config -DnewVersion=3.0
#https://issues.sonatype.org/browse/MVNCENTRAL-6872
#mvn versions:update-property -Dproperty=version.jakarta.validation -DnewVersion=3.0
sed -i '' 's/validation>2.0.2</validation>3.0.1</g' validator/pom.xml
mvn versions:update-property -Dproperty=version.hibernate.validator -DnewVersion=7.0.1.Final
mvn versions:update-property -Dproperty=version.jakarta.el -DnewVersion=4.0
mvn versions:update-property -Dproperty=version.smallrye.common -DnewVersion=2.0.0-RC1
mvn versions:update-property -Dproperty=version.smallrye.testing.utilities -DnewVersion=2.0.0-RC1
