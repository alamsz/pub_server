FROM --platform=$BUILDPLATFORM dart:stable as builder
WORKDIR /server
COPY pubspec.* .
RUN dart pub get
COPY . .
RUN dart pub get --offline
RUN dart compile exe server/server.dart -o /server/app

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=builder /runtime/ /
COPY --from=builder /server/app /server/

WORKDIR /app/packagedb

VOLUME /app/packagedb

EXPOSE 8080
ENTRYPOINT ["/server/app"]
