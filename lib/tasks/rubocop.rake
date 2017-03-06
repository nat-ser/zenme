# frozen_string_literal: true
require "rubocop/rake_task"

namespace :rubocop do
  desc "Run rubocop"
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ["--display-cop-names"]
  end
end
