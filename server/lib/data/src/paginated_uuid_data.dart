import 'paginated_data.dart';
import 'a_human_friendly_data.dart';
import 'package:dartalog/data/src/uuid_list.dart';
import 'package:dartalog/data/src/a_uuid_data.dart';

class PaginatedUuidData<T extends AUuidData> extends PaginatedData<T> {
  UuidDataList<T> _data = new UuidDataList<T>();

  @override
  UuidDataList<T> get data => _data;

  PaginatedUuidData();

  PaginatedUuidData.copyPaginatedData(PaginatedData<T> data) {
    this.totalCount = data.totalCount;
    this.limit = data.limit;
    this.startIndex = data.startIndex;
    this._data = new UuidDataList<T>.copy(data.data);
  }
}
