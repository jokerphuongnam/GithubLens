import Swinject
import Observation
import SwinjectAutoregistration
import GithubLensNetworks

final class DIManager {
    private static var container: Container!
    
    @MainActor
    class func register() {
        container = Container()
        container.register(GithubNetwork.self) { resolver in
            DataDI.defaultNetworkShared
        }.inObjectScope(.container)
        
        container.autoregister(GithubUsersRepository.self, initializer: GithubUsersRepositoryImpl.init).inObjectScope(.container)
        
        container.autoregister(GithubUsersUserCase.self, initializer: GithubUsersUserCaseImpl.init).inObjectScope(.container)
        
        container.autoregister(GithubUserDetailsUseCase.self, initializer: GithubUserDetailsUseCaseImpl.init).inObjectScope(.container)
    }
    
    class func get<T>() -> T {
        return container.resolve(T.self)!
    }
}
