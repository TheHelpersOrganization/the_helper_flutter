# Prepare web release
FROM plugfox/flutter:stable-web AS builder

# USER root
WORKDIR /usr/src/app

COPY . .

RUN set -eux
# Install dependencies
RUN flutter pub get
# Codegeneration
RUN flutter pub run build_runner build --delete-conflicting-outputs --release
# Build web release (opt --tree-shake-icons)
RUN flutter build web --release --no-source-maps \
    --pwa-strategy offline-first \
    --web-renderer canvaskit \
    --base-href /


FROM python:3-alpine as production

COPY --from=builder /usr/src/app/build/web ./

# Expose server
EXPOSE 8000

CMD [ "python", "-m", "http.server", "8000" ]