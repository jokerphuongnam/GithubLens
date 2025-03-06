// LoadMoreResource is a generic structure that encapsulates a resource with load-more functionality.
// It holds the current resource (data), the state of whether more data can be loaded,
// the current load-more status, and the current pagination page.
struct LoadMoreResource<T>: Hashable where T: Hashable {
    // The underlying resource containing an array of items of type T.
    var resource: Resource<Array<T>>
    
    // Indicates whether more data can be loaded.
    var prepareLoadMore: PrepareLoadMore
    
    // Holds the current state of the load-more operation (e.g., loading, error, etc.),
    // or nil if no load-more action is in progress.
    var loadMoreState: LoadMoreState?
    
    // The current page number used for pagination.
    var page: Int
    
    // Increments the page number by 1.
    mutating func increasePage() {
        page += 1
    }
    
    // Updates the resource by appending additional data.
    // This method calls the 'loadMore' function on the existing resource,
    // merging the current data with the new data provided.
    mutating func loadMore(moreData: Array<T>) {
        self.resource = resource.loadMore(moreData: moreData)
    }
}

// Enumeration to represent the ability to load more data.
enum PrepareLoadMore: Hashable {
    case canLoadMore    // Indicates that more data can be loaded.
    case cannotLoadMore // Indicates that loading more data is not allowed.
    case success        // Indicates that loading more data was successful.
}

// Enumeration representing the current state of the load-more process.
enum LoadMoreState: Hashable {
    case loading        // Indicates that more data is currently being loaded.
    case error(error: Error) // Indicates an error occurred during the load-more process.
}

// Custom conformance for LoadMoreState to handle equality and hashing,
// particularly for the 'error' case, since Error itself does not conform to Equatable.
extension LoadMoreState {
    // Custom equality operator.
    // Two LoadMoreState values are considered equal if:
    // - They are both in the .loading state, or
    // - They are both in the .error state and their errors' localized descriptions are equal.
    static func ==(lhs: LoadMoreState, rhs: LoadMoreState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(lhsError), .error(rhsError)):
            // Compare errors using their localizedDescription as a proxy for equality.
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    // Custom hash function for LoadMoreState.
    // Assigns a unique hash value based on the case:
    // - For .loading, a constant value (0) is used.
    // - For .error, combines a constant (1) with the hash of the error's localizedDescription.
    func hash(into hasher: inout Hasher) {
        switch self {
        case .loading:
            hasher.combine(0)
        case .error(let error):
            hasher.combine(1)
            // Use the localizedDescription to generate a hash value for the error.
            hasher.combine(error.localizedDescription)
        }
    }
}
