struct LoadMoreState<T>: Hashable where T: Hashable {
    var resource: Resource<T>
    var loadMore: PrepareLoadMore
    var page: Int
}

enum PrepareLoadMore: Hashable {
    case canLoadMore
    case cannotLoadMore
    case success
}
