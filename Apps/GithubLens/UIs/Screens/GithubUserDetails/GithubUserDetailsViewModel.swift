import Observation
import GithubLensNetworks

@Observable
final class GithubUserDetailsViewModel {
    private let useCase: GithubUserDetailsUseCase
    var loginUsername: String?
    var userDetailsState: Resource<GithubUserDetails> = .loading
    
    init(useCase: GithubUserDetailsUseCase) {
        self.useCase = useCase
    }
    
    func loadUserDetails(loginUsername: String) {
        self.loginUsername = loginUsername
        reloadUserDetails()
    }
    
    func reloadUserDetails() {
        guard let loginUsername else {
            return
        }
        userDetailsState = .loading
        Task(priority: .utility) {
            do {
                let userDetails = try await useCase.getGithubUserDetails(loginUsername: loginUsername)
                Task { @MainActor in
                    userDetailsState = .success(data: userDetails)
                }
            } catch {
                Task { @MainActor in
                    userDetailsState = .failure(error: error)
                }
            }
        }
    }
}
