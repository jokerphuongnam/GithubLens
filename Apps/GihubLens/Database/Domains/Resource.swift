enum Resource<T> {
    case loading
    case success(data: T)
    case failure(error: Error)
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
