 namespace :db do
     task :backup do
     system "mysqldump --opt --user=root --password=admin store_test > dbs/store_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
  end


  task :restore do
 #    system "mysqldump --user=root --password=admin  < store_backup.sql"
   end

  task :clean do
	Dir.foreach('/dbs') {|f| File.delete(f) if f != '.' && f != '..'}
   end
   
  desc "load user data from csv"
  task :load_csv_task  => :environment do
	require 'csv'
			CSV.foreach("public/products.csv", headers: true) do |row|
			 c = Product.new
			 c.category_id = Category.find_or_create_by_name(row[0]).id
			 c.name = row[1]
			 c.unit = row[2]
			 c.qty = 0
			 
			 c.save
			 invoice = Purchase.last ? Purchase.last.invoice.next : 1
			 d = Purchase.new(:invoice => invoice, :purchase_date => Date.today, :supplier_id => 1, :paid => 1)
			 d.purchase_products.build(:product_id => Product.find_by_name(row[1]).id, :qty => row[3].to_i, :cprice => row[4].to_f, :price => row[5].to_f)
			 d.save
			end
   end

  end