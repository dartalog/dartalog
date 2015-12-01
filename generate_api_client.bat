pub global activate rpc
pause
pub global run rpc:generate discovery -i lib/server/api/api.dart > json/cloud.json
pause
pub global activate discoveryapis_generator
pause
pub global run discoveryapis_generator:generate files -i json -o lib/client/api