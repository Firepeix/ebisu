set shell := ["cmd.exe", "/c"]

help:
  @just --list

build-dependencies:
  flutter packages pub run build_runner watch

release user:
    @just _release-{{user}}

_release-wewe:
  flutter build apk --dart-define=THEME=wewe --dart-define=TRAVEL_SHEET_ID=1OEA3xPP85ioFWrdR7RZD5gZlzKN267-fbrFUJQl5PWE --dart-define=USER=wewe --dart-define=FEATURES=expenses,travel --dart-define=EBISU_ENDPOINT=https://9ce7-2804-14c-5b74-ab85-00-1001.sa.ngrok.io --dart-define=AUTH_TOKEN=tewasdasd

_release-tutu:
  flutter build apk --dart-define=THEME=tutu --dart-define=TRAVEL_SHEET_ID=1OEA3xPP85ioFWrdR7RZD5gZlzKN267-fbrFUJQl5PWE --dart-define=USER=tutu --dart-define=FEATURES=expenses,shopping,books,travel --dart-define=EBISU_ENDPOINT=https://9ce7-2804-14c-5b74-ab85-00-1001.sa.ngrok.io --dart-define=AUTH_TOKEN=tewasdasd  