pub get --packages-dir
REM pub global activate rpc
REM pause
pub run rpc:generate discovery -i lib/server/api/item/item_api.dart > json/item.json
pause
REM pub global activate discoveryapis_generator
REM pause
pub run discoveryapis_generator:generate files -i json -o lib/client/api/src