#!/usr/bin/env bash

pub global activate rpc
pub global run rpc:generate discovery -i lib/server/api/api.dart > json/cloud.json
pub global activate discoveryapis_generator
pub global run discoveryapis_generator:generate files -i json -o lib/client/api
