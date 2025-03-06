import Swinject
import Observation
import SwinjectAutoregistration
import GithubLensNetworks

final class DIManager {
    // The dependency injection container, used to manage and resolve dependencies.
    // It is declared as an implicitly unwrapped optional and will be initialized during registration.
    private static var container: Container!
    
    // Registers all the necessary dependencies for the application.
    // The method is marked with @MainActor to ensure it runs on the main thread.
    @MainActor
    class func register() {
        // Initialize a new dependency injection container.
        container = Container()
        
        // Register GithubNetwork dependency.
        // Uses DataDI.defaultNetworkShared as the shared instance.
        // The instance is stored in a container-wide scope (singleton) for reuse.
        container.register(GithubNetwork.self) { resolver in
            DataDI.defaultNetworkShared
        }
        .inObjectScope(.container)
        
        // Automatically register GithubUsersRepository with its concrete implementation.
        // The container will create and store an instance of GithubUsersRepositoryImpl as a singleton.
        container.autoregister(GithubUsersRepository.self, initializer: GithubUsersRepositoryImpl.init)
            .inObjectScope(.container)
        
        // Automatically register GithubUsersUserCase with its concrete implementation.
        container.autoregister(GithubUsersUserCase.self, initializer: GithubUsersUserCaseImpl.init)
            .inObjectScope(.container)
        
        // Automatically register GithubUserDetailsUseCase with its concrete implementation.
        container.autoregister(GithubUserDetailsUseCase.self, initializer: GithubUserDetailsUseCaseImpl.init)
            .inObjectScope(.container)
    }
    
    // Retrieves a dependency from the container.
    // This force unwraps the resolved dependency, so it must only be called after the container has been configured.
    class func get<T>() -> T {
        return container.resolve(T.self)!
    }
}
