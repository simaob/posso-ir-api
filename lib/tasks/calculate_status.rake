namespace :status do
  desc 'Calculates the status for all stores'
  task calculate: :environment do
    puts "[#{Time.now}] Going to calculate the statuses from crowdsourcing"
    duration = Benchmark.ms do
      StatusCrowdsource.find_each.with_index do |s, i|
        puts "Calculated #{i}" if (i % 100).zero?
        s.calculate_status
      end
    end
    puts "Finished calculating the statuses in #{duration} ms"
  end
end
