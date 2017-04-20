pub get --packages-dir
pub run rpc:generate discovery -i lib/server/api/item/item_api.dart > json/item.json
pub run discoveryapis_generator:generate files -i json -o lib/client/api/src