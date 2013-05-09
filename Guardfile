notification :off

guard 'rspec', cli: '--format progress' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/.+\.rb$}) { 'spec' }
  watch(%r{^lib/(.+)\.rb$}) { |m| 'spec/#{m[1]}_spec.rb' }
  watch('spec/spec_helper.rb') { 'spec' }
end

guard 'cucumber', cli: '--format progress' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
  end
end
