require 'benchmark'
namespace :status_crowdsource do
  desc 'Generate a crowdsource_status for all the existing stores'
  task generate: :environment do
    puts "Going to generate the statuses"
    duration = Benchmark.ms do
      GenerateStatusCrowdsource.new.call
    end
    puts "Finished generating statuses in #{duration} ms"
  end
end
