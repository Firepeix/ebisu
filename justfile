set shell := ["cmd.exe", "/c"]

help:
  @just --list

add package:
  flutter pub add {{package}}  

remove package:
  flutter pub remove {{package}}

build:
  flutter packages pub run build_runner watch

release user:
    @just _release-{{user}}

_release-wewe:
  flutter build apk --dart-define=THEME=wewe --dart-define=TRAVEL_SHEET_ID=1OEA3xPP85ioFWrdR7RZD5gZlzKN267-fbrFUJQl5PWE --dart-define=USER=wewe --dart-define=FEATURES=expenses,travel --dart-define=EBISU_ENDPOINT=https://9ce7-2804-14c-5b74-ab85-00-1001.sa.ngrok.io --dart-define=AUTH_TOKEN=tewasdasd

_release-tutu:
  flutter build apk --dart-define=THEME=tutu --dart-define=TRAVEL_SHEET_ID=1OEA3xPP85ioFWrdR7RZD5gZlzKN267-fbrFUJQl5PWE --dart-define=USER=tutu --dart-define=FEATURES=expenses,shopping,books,travel --dart-define=EBISU_ENDPOINT=https://9ce7-2804-14c-5b74-ab85-00-1001.sa.ngrok.io --dart-define=AUTH_TOKEN=tewasdasd  

push type:
  just _push-{{type}}

_push-nubank title="Nova Compra" content="Compra de R$60,00 APROVADA em Picpay *RecargaCel.":
  just send-push '{{title}}' '{{content}}'

_push-caixa:
  just send-push "Nova Compra" "CAIXA: Compra Aprovada Uber *Uber R$24,94 04/12 as 00:44, VISA VIRTUAL final 6171. Caso nao reconheca a transacao, envie BL6171 p/ cancelar cartao"

send-push title="Nova Notificacao" content="Conteudo novo yada":
  D:\Languages\Android\Sdk\platform-tools\adb shell cmd notification post -S bigtext -t '{{title}}' 'Notification' '{{content}}'  

log: 
  @D:\Languages\Android\Sdk\platform-tools\adb logcat