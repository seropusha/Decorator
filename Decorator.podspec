# git tag 0.3.2
# git push origin 0.3.2
# pod lib lint Decorator.podspec --no-clean
# pod spec lint Decorator.podspec --allow-warnings
# pod trunk push Decorator.podspec

Pod::Spec.new do |s|

    s.name                  = 'Decorator'
    s.version               = '0.3.2'
    s.summary               = 'typealias Decoration<T> = (T) -> Void'
    s.description           = 'Generic decorator for UIView or any other class'
    s.homepage              = 'https://github.com/iwheelbuy/Decorator'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'iwheelbuy' => 'iwheelbuy@gmail.com' }
    s.source                = { :git => 'https://github.com/iwheelbuy/Decorator.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files          = 'Decorator/Classes/**/*'

end
