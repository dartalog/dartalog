pub global activate rpc 
pause
pub run rpc:generate discovery -i lib/server/api/api.dart   > json/cloud.json 
pause
pub global activate discoveryapis_generator
pause
pub run discoveryapis_generator:generate files -i json -o lib/client/api 