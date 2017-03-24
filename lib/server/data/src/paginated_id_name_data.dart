import 'paginated_data.dart';
import 'a_id_data.dart';
import 'id_name_list.dart';

class PaginatedIdNameData<T extends AIdData> extends PaginatedData<T> {
  IdNameList<T> _data = new IdNameList<T>();

  @override
  IdNameList<T> get data => _data;

  PaginatedIdNameData();

  PaginatedIdNameData.copyPaginatedData(PaginatedData<T> data) {
    this.totalCount = data.totalCount;
    this.limit = data.limit;
    this.startIndex = data.startIndex;
    this._data = new IdNameList<T>.copy(data.data);
  }
}
