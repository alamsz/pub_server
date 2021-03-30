FROM google/dart
# uncomment next line to ensure latest Dart and root CA bundle
#RUN apt -y update && apt -y upgrade
WORKDIR /server
COPY pubspec.* .
RUN pub get
COPY . .
RUN pub get --offline
RUN dart2native server/server.dart -o /server/app


FROM subfuzion/dart:slim
COPY --from=0 /server/app /app/bin/server
WORKDIR /app/packagedb

VOLUME /app/packagedb

EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]
