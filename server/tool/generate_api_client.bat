REM pub get --packages-dir
REM pub run rpc:generate discovery -i lib/server/api/item/item_api.dart > json/item.json
REM pub run discoveryapis_generator:generate files -i json -o lib/client/api/src

pub global activate discoveryapis_generator
pub global run discoveryapis_generator:generate package -i ../json -o ../../api_client --package-name=api_client