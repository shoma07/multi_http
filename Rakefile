# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :cargo_build do
  `cargo build --release`
  `cp target/release/libmulti_http.dylib lib/multi_http/`
end

task build: :cargo_build

task default: %i[cargo_build spec]
