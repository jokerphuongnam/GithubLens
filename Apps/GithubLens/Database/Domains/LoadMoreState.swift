struct LoadMoreResource<T>: Hashable where T: Hashable {
    var resource: Resource<Array<T>>
    var prepareLoadMore: PrepareLoadMore
    var loadMoreState: LoadMoreState?
    var page: Int
    
    mutating func increasePage() {
        page += 1
    }
    
    mutating func loadMore(moreData: Array<T>) {
        self.resource = resource.loadMore(moreData: moreData)
    }
}

enum PrepareLoadMore: Hashable {
    case canLoadMore
    case cannotLoadMore
    case success
}

enum LoadMoreState: Hashable {
    case loading
    case error(error: Error)
}

extension LoadMoreState {
    static func ==(lhs: LoadMoreState, rhs: LoadMoreState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(lhsError), .error(rhsError)):
            // Using localizedDescription as a proxy for equality.
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .loading:
            hasher.combine(0)
        case .error(let error):
            hasher.combine(1)
            // Again, using localizedDescription to generate a hash value.
            hasher.combine(error.localizedDescription)
        }
    }
}
