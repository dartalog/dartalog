part of data;

class PaginatedIdNameData<T extends AIdData> extends PaginatedData<T> {

  @override
  IdNameList<T> data = [];

  PaginatedIdNameData();
  
  PaginatedIdNameData.copyPaginatedData(PaginatedData<T> data) {
    this.totalCount = data.totalCount;
    this.limit = data.limit;
    this.startIndex = data.startIndex;
    this.data = new IdNameList<T>.copy(data.data);
  }
}