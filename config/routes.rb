Store::Application.routes.draw do




  get '/cb_sales_register' => 'sales#cb_sales_register'
  get '/purchase_register' => 'purchases#purchase_register'
  get '/sales_return_register' => 'sales#sales_return_register'
  get '/sales_register' => 'sales#sales_register'
  
  get '/day_sales' => 'sales#day_sales'
  get '/detailed_day_sales' => 'sales#detailed_day_sales'
#  get '/brand' => 'products#brand'
  get '/brand' => 'products#brand'
  get '/barcode_from_purchase/:id' => 'products#generate_barcode_from_purchase'
  get '/products/new_product' => 'products#new_product'
	get '/sale_return' => 'sales#sale_return'
  resources :sale_returns


  resources :variant_items

  resources :variants

  resources :payments
  resources :payment_receiveds
  resources :sold_products
  resources :units
  resources :password_resets
  resources :sessions
  resources :users
	
  get '/barby_barcode_generate' => 'products#barby_barcode_generate'
  get '/generate_barcode' => 'products#generate_barcode'
  get '/my_report_csv' => 'products#my_report_csv'
  get '/stock_report_pdf' => 'products#stock_report_pdf'
	get '/purchases/search' => 'purchases#search'
	get '/purchases/search_result' => 'purchases#search_result'
	get '/sales/search' => 'sales#search'
	get '/sales/search_result' => 'sales#search_result'
  get '/dead_stocks' => 'products#dead_stock'
	get '/purchases/last/:id' => 'purchases#last_od'
	get '/sales/last/:id' => 'sales#last_od'
  get '/graph' => 'products#graph'
  get '/calender' => 'products#calender'
  get '/barby_barcode' => 'products#barby_barcode'
  post '/barby_barcode_single' => 'products#barby_barcode_single'

  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'login', to: 'sessions#new', as: 'login'
  get 'signup', to: 'users#new', as: 'signup'

  get '/search_products' => 'products#search_products'
  get '/products/search' => 'products#search'
  get '/latest_stock_products/:id' => 'stock_products#latest_stock_products'
  
  get '/product_code/:id' => 'products#product_code'
  get '/products_name' => 'products#products_name'
  get '/product_show' => 'products#product_show'
  get '/stock_products_price/:id' => 'stock_products#stock_products_price'
  get '/barcode/barcode_single' => 'products#barcode_single'
  get '/barcode/barby_barcode_48' => 'products#barby_barcode_48'
  get '/barcode/barcode' => 'products#barcode'
  get '/backup' => 'products#backup'
  get '/count' => 'products#ecount'
#  post 'purchases/add_purchase_products' => 'purchases#add_purchase_products'
  match 'sales/add_sale_returns' => 'sales#add_sale_returns', via: [:get, :post]
  match 'sales/add_sale_products' => 'sales#add_sale_products', via: [:get, :post]
  match 'purchases/add_purchase_products' => 'purchases#add_purchase_products', via: [:get, :post]
  get '/select_date' => 'products#select_date'
	
	#  unknown action error
  get '/monthly_report' => 'products#monthly_report'
  get '/select_month' => 'products#select_month'
  get '/monthly_range_report' => 'products#monthly_range_report'
  get '/select_month_range' => 'products#select_month_range'
  get '/sales/monthly_range_report' => 'sales#monthly_range_report'
  get '/sales/select_month_range' => 'sales#select_month_range'
  get '/monthly_report_pdf' => 'products#monthly_report_pdf'
  get '/close_stock' => 'products#close_stock'
  get '/close_date' => 'products#close_date'
  get '/blank_invoice' => 'purchases#blank_invoice'
  get '/create_purchase/:id' => 'purchases#create_purchase'
  get '/new_purchase/:id' => 'purchases#new_purchase'
  get '/purchases/payables' => 'purchases#payables'
  get '/sales/receivables' => 'sales#receivables'
  get '/pay-now/:id' => 'purchases#pay_now'
  get '/receive-now/:id' => 'sales#receive_now'
	
  get '/purchases/supplier_report' => 'purchases#supplier_report'
  get '/supplier_wise_report' => 'purchases#supplier_wise_report'
  get '/sales/customer_report' => 'sales#customer_report'
  get '/sales/report' => 'sales#report'
  get '/daily_report' => 'products#daily_report'
  get '/daily_report_pdf' => 'products#daily_report_pdf'
  get '/sales/detailed_report' => 'sales#detailed_report'
  get '/sale_report' => 'sales#sale_report'
  get '/purchases/report' => 'purchases#report'
  get '/purchase_report' => 'purchases#purchase_report'
  get '/purchase_report_pdf' => 'purchases#purchase_report_pdf'
	
	get '/stock_report' => 'products#stock_report'
	
	get '/sales/:id/exchange' => 'sales#sales_exchange'
	get '/sales/:id/return' => 'sales#sales_return'
	get '/purchases/:id/return' => 'purchases#purchase_return'
  
	
  resources :categories
  resources :suppliers
  resources :customers
  resources :stock_products
  resources :sale_products
  resources :purchase_products
  resources :sales
  resources :purchases

  resources :products do
		collection { post :import }
  end



   root :to => 'products#home'

end
