import Observation
import GithubLensNetworks

// Mark the view model as observable so that any changes trigger UI updates.
@Observable
final class GithubUserDetailsViewModel {
    // Dependency on the use case that fetches GitHub user details.
    private let useCase: GithubUserDetailsUseCase
    
    // Holds the login username for which the user details will be fetched.
    var loginUsername: String?
    
    // Represents the current state of user details (loading, success with data, or failure with an error).
    var userDetailsState: Resource<GithubUserDetails> = .loading
    
    // Initializer that injects the GithubUserDetailsUseCase dependency.
    init(useCase: GithubUserDetailsUseCase) {
        self.useCase = useCase
    }
    
    // Public method to initiate the loading of user details for a given login username.
    func loadUserDetails(loginUsername: String) {
        // Store the provided login username.
        self.loginUsername = loginUsername
        // Trigger the fetching process.
        reloadUserDetails()
    }
    
    // Reloads the user details based on the current loginUsername.
    func reloadUserDetails() {
        // Ensure that loginUsername is available; if not, exit early.
        guard let loginUsername else {
            return
        }
        
        // Set the state to loading to indicate a network call is in progress.
        userDetailsState = .loading
        
        // Create an asynchronous task with utility priority.
        Task(priority: .utility) {
            do {
                // Attempt to fetch the user details asynchronously.
                let userDetails = try await useCase.getGithubUserDetails(loginUsername: loginUsername)
                // Once data is fetched, update the UI on the main thread.
                Task { @MainActor in
                    userDetailsState = .success(data: userDetails)
                }
            } catch {
                // If an error occurs, update the state on the main thread to reflect the failure.
                Task { @MainActor in
                    userDetailsState = .failure(error: error)
                }
            }
        }
    }
}
