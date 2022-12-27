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

_push-nubank: (send-push "Nova Compra" 'Compra de R$ 60,00 APROVADA em Picpay *RecargaCel.')

_push-caixa: (send-push "Nova Compra" "CAIXA: Compra Aprovada Uber *Uber R$ 24,94 04/12 as 00:44, VISA VIRTUAL final 6171. Caso nao reconheca a transacao, envie BL6171 p/ cancelar cartao")

_push-picpay: (send-push "Nova Compra" "Sua compra no valor de R$ 77,97 em Ifood *ifood Sao Paulo Br foi Aprovada")

send-push title="Titulo" content="Conteudo":
  D:\Languages\Android\Sdk\platform-tools\adb shell cmd notification post -S bigtext -t '{{title}}' 'Notification' '{{content}}'

log: 
  @D:\Languages\Android\Sdk\platform-tools\adb logcat
device: 
  @D:\Languages\Android\Sdk\platform-tools\adb devices  

send-sms:
  @D:\Languages\Android\Sdk\platform-tools\adb shell service call isms 5 i32 0 s16 "com.android.mms" s16 "null" s16 "+5531991896142" s16 "null" s16 "Teste" s16 "null" s16 "null" i32 0 i64 0
list-services:
  @D:\Languages\Android\Sdk\platform-tools\adb shell service list  

emulator-send:
  @D:\Languages\Android\Sdk\platform-tools\adb shell service call isms 5 i32 0 s16 "com.android.mms" s16 "null" s16 "+16505556789" s16 "null" s16 "Ola" s16 "null" s16 "null" i32 0 i64 0  