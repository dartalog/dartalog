library data_sources;

import 'dart:html';
import 'dart:async';
import 'dart:indexed_db' as idb;

import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/data/data.dart';

part 'src/a_data_source.dart';
part 'src/settings_data_source.dart';
part 'src/cart_data_source.dart';

final SettingsDataSource settings = new SettingsDataSource();
final CartDataSource cart = new CartDataSource();