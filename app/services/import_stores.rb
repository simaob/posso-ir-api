class ImportStores
  def call
    cleanup
    import_auchan
    puts "#{Store.count} stores added"
  end

  def cleanup
    Store.delete_all
  end

  def import_auchan
    src = File.open(Rails.root.join('db', 'files', 'AUCHAN.csv'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    CSV.parse(file, headers:true, skip_blanks: true). each do |csv|
      Store.create(
        name: csv['name'],
        group: 'Auchan',
        city: csv['city'],
        latitude: csv['lat'],
        longitude: csv['lng']
      )
    end
  end
end
