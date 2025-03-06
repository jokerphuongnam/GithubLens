enum Resource<T> {
    // Represents the current state of a resource that is being loaded.
    case loading                   // The resource is in the process of loading.
    case success(data: T)          // The resource has loaded successfully and holds data of type T.
    case failure(error: Error)     // The resource failed to load with an associated error.
    
    // A computed property that returns the data if the resource is in a success state, or nil otherwise.
    var data: T? {
        if case let .success(data) = self {
            return data
        }
        return nil
    }
    
    // A computed property that returns the error if the resource is in a failure state, or nil otherwise.
    var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
    
    // A helper function to append more data to the resource if it holds an array.
    // This function is only available when T is an Array of some type E.
    func loadMore<E>(moreData: T) -> Self where T == Array<E> {
        // If the current resource is in the success state, try to append more data.
        if var data {
            data.append(contentsOf: moreData)
            // Return a new success state with the updated data.
            return .success(data: data)
        }
        // If the resource is not in a success state, return self unchanged.
        return self
    }
}

// Extend Resource to conform to Equatable when the underlying data type T is Equatable.
extension Resource: Equatable where T: Equatable {
    static func == (lhs: Resource<T>, rhs: Resource<T>) -> Bool {
        switch (lhs, rhs) {
            // Both resources are loading.
        case (.loading, .loading):
            return true
            // Both resources succeeded and their data are equal.
        case (.success(let lhsData), .success(let rhsData)):
            return lhsData == rhsData
            // Both resources failed and their errors have the same localized description.
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
            // In all other cases, the resources are not equal.
        default:
            return false
        }
    }
}

// Extend Resource to conform to Hashable when the underlying data type T is Hashable.
extension Resource: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .loading:
            // Use a constant to represent the loading state.
            hasher.combine(0)
        case .success(let data):
            // Combine a constant and the data hash for the success state.
            hasher.combine(1)
            hasher.combine(data)
        case .failure(let error):
            // Combine a constant and the error's localized description for the failure state.
            hasher.combine(2)
            hasher.combine(error.localizedDescription)
        }
    }
}
