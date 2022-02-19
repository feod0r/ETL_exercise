

--select * from fact_transactions;
--select count(1) from fact_transactions;


--добавление уникальных записей клиентов и обновление дубликатов
insert into clients (client_id, last_name, first_name, patrinymic, date_of_birth, passport_num, passport_valid_to, phone) 
    select DISTINCT client_id, last_name, first_name, patro, date_of_birth, passport, passport_valid_to, phone from fact_transactions
    on conflict (client_id) do nothing;
   
with new_data as(select DISTINCT client_id, last_name, first_name, patro, date_of_birth, passport, passport_valid_to, phone from fact_transactions 
	where (client_id, last_name, first_name, patro, date_of_birth, passport, passport_valid_to, phone ) not in (select * from clients))
	update clients set (last_name, first_name, patrinymic, date_of_birth, passport_num, passport_valid_to, phone ) =
		(new_data.last_name, new_data.first_name, new_data.patro, new_data.date_of_birth, new_data.passport, new_data.passport_valid_to, new_data.phone) 
		from new_data where clients.client_id = new_data.client_id;
--добавление уникальных аккаунтов и обновление дубликатов
insert into accounts (account_num, valid_to, client) 
	select distinct account_id, account_valid_to, client_id from fact_transactions
	where not exists (select 1 from accounts where fact_transactions.account_id = accounts.account_num)
	on conflict (account_num) do nothing;
	
with new_data as(select DISTINCT account_id, account_valid_to, client_id from fact_transactions 
	where (account_id, account_valid_to, client_id ) not in (select * from accounts))
	update accounts set (valid_to, client) =
		(new_data.account_valid_to, new_data.client_id) 
		from new_data where accounts.account_num = new_data.account_id;

--добавление уникальных карт и обновление дубликатов
insert into cards (card_num, account_num) 
	select distinct card_num, account_id from fact_transactions
	where not exists (select 1 from cards where fact_transactions.card_num = cards.card_num)
	on conflict (card_num) do nothing;
	
with new_data as(select DISTINCT card_num, account_id from fact_transactions
	where (card_num, account_id) not in (select * from cards))
	update cards set account_num = new_data.account_id
		from new_data where cards.card_num = new_data.card_num;

--добавление уникальных терминалов и обновление дубликатов
insert into terminals (terminal_id, terminal_type, terminal_city, terminal_address) 
	select distinct terminal, terminal_type, city, address from fact_transactions
	where not exists (select 1 from terminals where fact_transactions.terminal = terminals.terminal_id)
	on conflict (terminal_id) do nothing;
	
with new_data as(select DISTINCT terminal, terminal_type, city, address from fact_transactions 
	where (terminal, terminal_type, city, address) not in (select * from terminals))
	update terminals set (terminal_type, terminal_city, terminal_address) =
		(new_data.terminal_type, new_data.city, new_data.address) 
		from new_data where terminals.terminal_id = new_data.terminal;
	
--обновлять не нужно
insert into transactions (trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal) 
	select distinct trans_id, trans_date, card_num, oper_type, amount, oper_result, terminal from fact_transactions
	where not exists (select 1 from transactions where fact_transactions.trans_id = transactions.trans_id);
--без проверки
--insert into transactions (trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal) 
--	select trans_id, trans_date, card_num, oper_type, amount, oper_result, terminal from fact_transactions;

--select count(1) from transactions;

--select * from clients where client_id = '2-21448';

--update clients set last_name = 'anton' where client_id = '1-67071';
    	
--select * from clients;
--select * from dim_clients_hist; 
--select trans_id, count(1) from dim_transactions_hist dth group by trans_id order by trans_id; 
--select * from transactions where trans_id = '459271267.0';

--select trans_date from fact_transactions;