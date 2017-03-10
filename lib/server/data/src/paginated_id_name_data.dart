import 'paginated_data.dart';
import 'package:dartalog/data/src/a_id_data.dart';
import 'id_name_list.dart';

class PaginatedIdNameData<T extends AIdData> extends PaginatedData<T> {
  @override
  IdNameList<T> data = new IdNameList<T>();

  PaginatedIdNameData();

  PaginatedIdNameData.copyPaginatedData(PaginatedData<T> data) {
    this.totalCount = data.totalCount;
    this.limit = data.limit;
    this.startIndex = data.startIndex;
    this.data = new IdNameList<T>.copy(data.data);
  }
}
