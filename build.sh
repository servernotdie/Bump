./gradlew --stop
rm -rf ~/.m2/repository/com/github/servernotdie
bash install.sh
./gradlew clean build --no-daemon --no-configuration-cache
