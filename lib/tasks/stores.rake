namespace :stores do
  desc 'Import stores into database'
  task import: :environment do
    Importer::ImportStores.new.all
  end

  task cleanup: :environment do
    Importer::ImportStores.new.cleanup
  end

  task aldi: :environment do
    Importer::ImportStores.new.import_aldi
  end

  task apolonia: :environment do
    Importer::ImportStores.new.import_apolonia
  end

  task auchan: :environment do
    Importer::ImportStores.new.import_auchan
  end

  task continente: :environment do
    Importer::ImportStores.new.import_continente
  end

  task corte_ingles: :environment do
    Importer::ImportStores.new.import_corte_ingles
  end

  task coviran: :environment do
    Importer::ImportStores.new.import_coviran
  end

  task eleclerc: :environment do
    Importer::ImportStores.new.import_eleclerc
  end

  task froiz: :environment do
    Importer::ImportStores.new.import_froiz
  end

  task intermarche: :environment do
    Importer::ImportStores.new.import_intermarche
  end

  task lidl: :environment do
    Importer::ImportStores.new.import_lidl
  end

  task mercadona: :environment do
    Importer::ImportStores.new.import_mercadona
  end

  task minipreco: :environment do
    Importer::ImportStores.new.import_minipreco
  end

  task pingo_doce: :environment do
    Importer::ImportStores.new.import_pingo_doce
  end

  task spar: :environment do
    Importer::ImportStores.new.import_spar
  end

  task pharmacies: :environment do
    Importer::ImportStores.new.import_pharmacies
  end

  task prio: :environment do
    Importer::ImportStores.new.import_prio
  end

  task dia: :environment do
    Importer::ImportStores.new.import_dia
  end

  task osm: :environment do
    Importer::ImportStores.new.import_from_osm
  end

  task :osm_from, [:country] => :environment do |_t, args|
    Importer::ImportOsm.new.import(args.country)
  end

  task spanish_stores: :environment do
    Importer::ImportStores.new.import_spanish_stores
  end

  task continente_from_api: :environment do
    Importer::ImportStores.new.import_continente_from_api
  end

  task meu_super: :environment do
    Importer::ImportStores.new.import_meu_super
  end

  task deco_beaches: :environment do
    Importer::ImportBeaches.new.import_beaches_deco
  end

  task apa_beaches: :environment do
    Importer::ImportBeaches.new.import_beaches_apa
  end

  task update_beaches_apa: :environment do
    Importer::ImportBeaches.new.update_beaches_apa
  end
end
