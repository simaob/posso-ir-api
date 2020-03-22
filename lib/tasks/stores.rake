namespace :stores do
  desc 'Import stores into database'
  task import: :environment do
    ImportStores.new.all
  end

  task cleanup: :environment do
    ImportStores.new.cleanup
  end

  task auchan: :environment do
    ImportStores.new.import_auchan
  end

  task continente: :environment do
    ImportStores.new.import_continente
  end

  task corte_ingles: :environment do
    ImportStores.new.import_corte_ingles
  end

  task intermarche: :environment do
    ImportStores.new.import_intermarche
  end

  task lidl: :environment do
    ImportStores.new.import_lidl
  end

  task mercadona: :environment do
    ImportStores.new.import_mercadona
  end

  task minipreco: :environment do
    ImportStores.new.import_minipreco
  end

  task pingo_doce: :environment do
    ImportStores.new.import_pingo_doce
  end
end
