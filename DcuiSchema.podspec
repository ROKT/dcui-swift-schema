Pod::Spec.new do |s|
  s.name             = 'DcuiSchema'
  s.version          = '2.7.0-alpha.1'
  s.summary          = 'DCUI layout schema types for the Rokt SDK ecosystem.'
  s.swift_version    = '5.7'

  s.description      = <<-DESC
  Swift types defining layout schema models, nodes, and styles for the
  Dynamically Composable User Interface (DCUI) used across Rokt SDKs.
  Zero external dependencies.
                       DESC

  s.homepage         = 'https://github.com/ROKT/dcui-swift-schema'
  s.license          = { :type => 'Rokt SDK Terms of Use 2.0', :file => 'LICENSE.md' }
  s.author           = { 'Rokt' => 'nativeappsdev@rokt.com' }
  s.source           = { :git => 'https://github.com/ROKT/dcui-swift-schema.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files     = 'Sources/DcuiSchema/**/*.swift'
  s.frameworks       = 'Foundation'
end
