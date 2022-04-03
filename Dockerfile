# syntax=docker/dockerfile:1
# On the basis of https://hub.docker.com/_/dart

FROM dart:stable AS app
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY bin/ ./bin/
COPY lib/ ./lib/
COPY analysis_options.yaml ./
RUN dart pub get --offline
RUN dart compile exe /app/bin/miwula_waiting_time.dart -o /app/bin/miwula_waiting_time
RUN chmod +x ./bin/miwula_waiting_time

FROM scratch
COPY --from=app /runtime/ /
COPY --from=app /app/bin/miwula_waiting_time /miwula_waiting_time

CMD ["/miwula_waiting_time"]