create or replace view operations as select trans_id, trans_date, cards.card_num card_num, oper_type, amt, oper_result, cards.account_num account_num, valid_to, client_id, last_name, first_name, patrinymic, date_of_birth, passport_num, passport_valid_to, phone, terminal_city
	from transactions 
	left join cards on transactions.card_num = cards.card_num 
	left join accounts on cards.account_num = accounts.account_num 
	left join clients on clients.client_id = accounts.client
	left join terminals on transactions.terminal = terminals.terminal_id;
	
--select * from operations;

--поиск операций с просроченным паспортом
insert into report select trans_date,
	passport_num,
	last_name || ' ' || first_name || ' ' || patrinymic fio,
	phone, 'просрочен паспорт ' || passport_valid_to FRAUD_TYPE,
	current_timestamp
from operations where trans_date > passport_valid_to;

--поиск операций с просроченным договором
insert into report select trans_date,
	passport_num,
	last_name || ' ' || first_name || ' ' || patrinymic fio,
	phone,
	'просрочен договор' || ' ' || account_num || ' (' || trans_date || '->' || valid_to || ')' FRAUD_TYPE,
	current_timestamp
from operations where trans_date > valid_to;


--поиск операций в разных городах
insert into report select trans_date, 
	passport_num,
	fio,
	phone,
	FRAUD_TYPE,
	current_timestamp
	from (select trans_date, 
		passport_num, 
		last_name || ' ' || first_name || ' ' || patrinymic fio, 
		phone,
		'транзакции в разных городах ' || terminal_city || '->' || lead(terminal_city) over (partition by card_num order by trans_date) || ' за ' || lead(trans_date) over (partition by card_num order by trans_date)- trans_date  FRAUD_TYPE, 
		amt, 
		terminal_city, 
		lead(terminal_city) over (partition by card_num order by trans_date) ld_city,
		lead(trans_date) over (partition by card_num order by trans_date)- trans_date a 
	from operations) tab 
	where a < '1 hour' and ld_city != terminal_city;

--поиск операций с подбором сумм
insert into report select trans_date,
	passport_num,
	fio,
	phone,
	'успешный подбор сумм в течение 20 минут: ' || amt3 || '(f)->' || amt2 || '(f)->' || amt1 || '(ok)' FRAUD_TYPE,
	current_timestamp
	from (select trans_date, 
		passport_num, 
		last_name || ' ' || first_name || ' ' || patrinymic fio, 
		phone,
		amt, 
		oper_result,
		lag(trans_date) over (partition by card_num order by trans_date) lg1,
		lag(trans_date,2) over (partition by card_num order by trans_date) lg2,
		lag(trans_date,3) over (partition by card_num order by trans_date) lg3,
		lag(amt) over (partition by card_num order by trans_date) amt1,
		lag(amt,2) over (partition by card_num order by trans_date) amt2,
		lag(amt,3) over (partition by card_num order by trans_date) amt3
	from operations) tab 
	where (lg1 is not null and lg2 is not null and lg3 is not null) and ((trans_date - lg3))< '20 min' and (amt1 < amt2 and amt2 < amt3) and oper_result = '”спешно';
	

--select * from report;


