# git tag 0.1.0
# git push origin 0.1.0
# pod lib lint Decorator.podspec --no-clean
# pod spec lint Decorator.podspec --allow-warnings
# pod trunk push Decorator.podspec

Pod::Spec.new do |s|

    s.name                  = 'Decorator'
    s.version               = '0.1.0'
    s.summary               = 'A short description of Decorator.'
    s.description           = 'A detailed description of Decorator.'
    s.homepage              = 'https://github.com/iwheelbuy/Decorator'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'iwheelbuy' => 'iwheelbuy@gmail.com' }
    s.source                = { :git => 'https://github.com/iwheelbuy/Decorator.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files          = 'Decorator/Classes/**/*'

end
