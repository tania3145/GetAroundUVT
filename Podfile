# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GetAroundUVT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GetAroundUVT
  pod 'GoogleMaps', '7.4.0'
  pod 'Google-Maps-iOS-Utils', '~> 4.1.0'
  pod 'GTMSessionFetcher', :modular_headers => true
  pod 'GoogleAPIClientForREST', '~> 1.2.1'
  pod 'GoogleSignIn', '~> 4.1.1'
  pod 'FirebaseAuth', '~> 9.6.0'
  pod 'FirebaseFirestore', '~> 9.6.0'
  
  target 'GetAroundUVTTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GetAroundUVTUITests' do
    # Pods for testing
  end

  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end
end
