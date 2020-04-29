require 'benchmark'
namespace :generate do
  desc 'Generate a crowdsource_status for all the existing stores'
  task status_crowdsource: :environment do
    puts "[#{Time.current}] Going to generate the crowdsource statuses"
    duration = Benchmark.ms do
      GenerateStatusCrowdsource.new.call
    end
    puts "Finished generating crowdsource statuses in #{duration} ms"
  end

  desc 'Generate store_owner statuses for all the existing stores'
  task status_store_owner: :environment do
    puts "[#{Time.current}] Going to generate the store owner statuses"
    duration = Benchmark.ms do
      GenerateStatusStoreOwner.new.call
    end
    puts "Finished generating store owner statuses in #{duration} ms"
  end

  desc 'Generate general statuses for all the existing stores'
  task status_general: :environment do
    puts "[#{Time.current}] Going to generate the general statuses"
    duration = Benchmark.ms do
      GenerateStatusGeneral.new.call
    end
    puts "Finished generating general statuses in #{duration} ms"
  end
end
