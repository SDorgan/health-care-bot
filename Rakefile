require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RACK_ENV = ENV['RACK_ENV'] ||= ENV['RACK_ENV'] ||= 'test' unless defined?(RACK_ENV)
API_KEY = ENV['API_KEY'] ||= ENV['API_KEY'] ||= 'altojardin' unless defined?(API_KEY)

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
  task.requires << 'rubocop-rspec'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec_report) do |t|
  t.pattern = './spec/**/*_spec.rb'
  t.rspec_opts = %w[--format RspecJunitFormatter --out reports/spec/spec.xml]
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec_report) do |t|
  t.pattern = './spec/**/*_spec.rb'
  t.rspec_opts = '--color --format d'
end

task default: %i[spec rubocop]
