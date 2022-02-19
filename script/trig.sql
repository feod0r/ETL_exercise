--аудит клиентов
CREATE OR REPLACE FUNCTION clients_audit() RETURNS TRIGGER AS $clients_audit$
    begin
	    IF (TG_OP = 'INSERT') then
	    	insert into dim_clients_hist select new.*, current_timestamp, '01.01.9999';
	    	return new;
	    ELSIF (TG_OP = 'UPDATE') then
	    	update dim_clients_hist set end_dt = current_timestamp where client_id = new.client_id and 
	    		start_dt = (select max(start_dt) from dim_clients_hist where client_id = new.client_id);
	    	insert into dim_clients_hist select new.*, (select max(start_dt) from dim_clients_hist where client_id = new.client_id), '01.01.9999';
	    	return new;
	    end if; 
	    RETURN NULL;
    end
$clients_audit$ LANGUAGE plpgsql;

CREATE TRIGGER clients_audit
AFTER INSERT OR UPDATE ON clients
    FOR EACH ROW EXECUTE PROCEDURE clients_audit();

--аудит аккаунтов
CREATE OR REPLACE FUNCTION accounts_audit() RETURNS TRIGGER AS $clients_audit$
    begin
	    IF (TG_OP = 'INSERT') then
	    	insert into dim_accounts_hist select new.*, current_timestamp, '01.01.9999';
	    	return new;
	    ELSIF (TG_OP = 'UPDATE') then
	    	update dim_accounts_hist set end_dt = current_timestamp where account_num = new.account_num and
	    		start_dt = (select max(start_dt) from dim_accounts_hist where account_num = new.account_num);
	    	insert into dim_accounts_hist select new.*, (select max(start_dt) from dim_accounts_hist where account_num = new.account_num), '01.01.9999';
	    	return new;
	    end if; 
	    RETURN NULL;
    end
$clients_audit$ LANGUAGE plpgsql;

CREATE TRIGGER accounts_audit
AFTER INSERT OR UPDATE ON accounts
    FOR EACH ROW EXECUTE PROCEDURE accounts_audit();
    
--аудит карт
CREATE OR REPLACE FUNCTION cards_audit() RETURNS TRIGGER AS $clients_audit$
    begin
	    IF (TG_OP = 'INSERT') then
	    	insert into dim_cards_hist select new.*, current_timestamp, '01.01.9999';
	    	return new;
	    ELSIF (TG_OP = 'UPDATE') then
	    	update dim_cards_hist set end_dt = current_timestamp where card_num = new.card_num and
	    		start_dt = (select max(start_dt) from dim_cards_hist where card_num = new.card_num);
	    	insert into dim_cards_hist select new.*, (select max(start_dt) from dim_cards_hist where card_num = new.card_num), '01.01.9999';
	    	return new;
	    end if; 
	    RETURN NULL;
    end
$clients_audit$ LANGUAGE plpgsql;

CREATE TRIGGER cards_audit
AFTER INSERT OR UPDATE ON cards 
    FOR EACH ROW EXECUTE PROCEDURE cards_audit();
    
--аудит терминалов
CREATE OR REPLACE FUNCTION terminals_audit() RETURNS TRIGGER AS $clients_audit$
    begin
	    IF (TG_OP = 'INSERT') then
	    	insert into dim_terminals_hist select new.*, current_timestamp, '01.01.9999';
	    	return new;
	    ELSIF (TG_OP = 'UPDATE') then
	    	update dim_terminals_hist set end_dt = current_timestamp where terminal_id = new.terminal_id and
	    		start_dt = (select max(start_dt) from dim_terminals_hist where terminal_id = new.terminal_id);
	    	insert into dim_terminals_hist select new.*, (select max(start_dt) from dim_terminals_hist where terminal_id = new.terminal_id), '01.01.9999';
	    	return new;
	    end if; 
	    RETURN NULL;
    end
$clients_audit$ LANGUAGE plpgsql;

CREATE TRIGGER terminals_audit
AFTER INSERT OR UPDATE ON terminals 
    FOR EACH ROW EXECUTE PROCEDURE terminals_audit();   
 
--аудит транзакций
CREATE OR REPLACE FUNCTION transactions_audit() RETURNS TRIGGER AS $clients_audit$
    begin
	    IF (TG_OP = 'INSERT') then
	    	insert into dim_transactions_hist select new.*, current_timestamp, '01.01.9999';
	    	return new;
	    ELSIF (TG_OP = 'UPDATE') then
	    	update dim_transactions_hist set end_dt = current_timestamp where trans_id = new.trans_id and
	    		start_dt = (select max(start_dt) from dim_transactions_hist where trans_id = new.trans_id);
	    	insert into dim_transactions_hist select new.*, (select max(start_dt) from dim_transactions_hist where trans_id = new.trans_id), '01.01.9999';
	    	return new;
	    end if; 
	    RETURN NULL;
    end
$clients_audit$ LANGUAGE plpgsql;

CREATE TRIGGER transactions_audit
AFTER INSERT OR UPDATE ON transactions 
    FOR EACH ROW EXECUTE PROCEDURE transactions_audit(); 
