FROM dart:stable
WORKDIR /server
COPY pubspec.* .
RUN dart pub get
COPY . .
RUN dart pub get --offline
RUN dart compile exe server/server.dart -o /server/app

WORKDIR /app/packagedb

VOLUME /app/packagedb

EXPOSE 8080
ENTRYPOINT ["/server/app"]
