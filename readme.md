# GithubLens

GithubLens is an iOS application that leverages SwiftGen to generate type-safe resources, including assets and localization files. This README provides instructions to set up the project, install required dependencies, and run SwiftGen.

## Prerequisites

- **Xcode**: Ensure you have the latest version of Xcode installed.
- **Homebrew**: If you don't have Homebrew installed, you can install it from [brew.sh](https://brew.sh/).
- **SwiftGen**: Used for generating type-safe resource references.

## Installation

1. **Clone the Repository**

   Open your terminal and clone the repository:
   ```bash
   git clone https://github.com/jokerphuongnam/GithubLens.git
   ```
   
   Then, navigate into the project directory:
   ```bash
   cd GithubLens
   ```
  
2. **Install SwiftGen**

   Update Homebrew and install SwiftGen by running:
   ```bash
   brew update
   brew install swiftgen
   ```

3. **Create the Generated Folder**

   After running SwiftGen, ensure that the generated files are stored in the ```./Apps/GithubLens/Generated``` directory. If the folder does not exist, create it with the following command:
   ```bash
   mkdir -p ./Apps/GithubLens/Generated
   ```
     
4. **Run SwiftGen**

   After installing SwiftGen, generate the resources using the provided configuration file. Replace the path if your ```swiftgen.yml``` is located elsewhere:
   ```bash
   swiftgen config run --config ./Apps/swiftgen.yml
   ```

## Project Setup

   - **SwiftGen Configuration:** The configuration file (`swiftgen.yml`) is located in the `Apps` directory. It defines how SwiftGen should process assets, strings, and other resources.

   - **Development:** Open the project in Xcode and build/run the application. Make sure to run SwiftGen whenever you update resources to keep the generated files in sync.

## Usage

   - **Resource Management:** SwiftGen ensures that all asset and localization references are type-safe. Refer to the generated files in your project for usage examples.
   - **Continuous Integration:** Consider adding SwiftGen as a build phase in Xcode to automate resource generation with each build

## Contributing
   Contributions to GithubLens are welcome. Please follow these steps:

   1. Fork the repository.
   2. Create a new branch for your feature or bugfix.
   3. Commit your changes with clear descriptions.
   4. Open a pull request detailing your changes.
