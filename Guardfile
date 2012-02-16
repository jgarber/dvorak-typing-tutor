guard 'jasmine' do
  watch(%r{^app/assets/javascripts/([^\.]+)\.(js\.coffee|js|coffee)$}) { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
  watch(%r{^spec/javascripts/(.+)_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$})           { "spec/javascripts" }
  watch(%r{^app/assets/javascripts/app/app\.(js\.coffee|js|coffee)$}) { "spec/javascripts" }
  watch(%r{^app/assets/javascripts/application\.(js\.coffee|js|coffee)$}) { "spec/javascripts" }
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard 'cucumber', cli: '-c --drb --format progress --no-profile' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
