enum Resource<T> {
    case loading
    case success(data: T)
    case failure(error: Error)
    
    var data: T? {
        if case let .success(data) = self {
            return data
        }
        return nil
    }
    
    var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
    
    func loadMore<E>(moreData: T) -> Self where T == Array<E> {
        if var data {
            data.append(contentsOf: moreData)
            return .success(data: data)
        }
        return self
    }
}

extension Resource: Equatable where T: Equatable {
    static func == (lhs: Resource<T>, rhs: Resource<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.success(let lhsData), .success(let rhsData)):
            return lhsData == rhsData
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

extension Resource: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .loading:
            hasher.combine(0)
        case .success(let data):
            hasher.combine(1)
            hasher.combine(data)
        case .failure(let error):
            hasher.combine(2)
            hasher.combine(error.localizedDescription)
        }
    }
}
