# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'go build'
task :go_build do
  `go build -buildmode=c-shared -o lib/multi_http/multi_http.so src/lib.go`
end

desc 'cargo build'
task :cargo_build do
  `cargo build --release`
  `cp target/release/libmulti_http.dylib lib/multi_http/`
end

desc 'build'
task build: %i[go_build]

task default: %i[go_build spec]
