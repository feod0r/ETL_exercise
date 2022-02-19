DROP TABLE if exists transactions cascade;
DROP TABLE if exists cards cascade;
DROP TABLE if exists accounts cascade;
DROP TABLE if exists terminals cascade;
DROP TABLE if exists clients cascade;

create table clients (
    client_id varchar(100),
    last_name varchar(100),
    first_name varchar(100),
    patrinymic varchar(100),
    date_of_birth timestamp,
    passport_num varchar(100),
    passport_valid_to timestamp, 
    phone varchar(100),

    CONSTRAINT pk_clients
        PRIMARY key (client_id)
	distributed by randomly
    );
    
    
create table accounts (
    account_num varchar(100),
    valid_to timestamp,
    client varchar(100),

    CONSTRAINT pk_accounts
        unique (account_num),
    CONSTRAINT fk_accounts
        FOREIGN KEY (client)
        REFERENCES clients(client_id)
	distributed by randomly
    );
    
create table cards (
    card_num varchar(100),
    account_num varchar(100),

    CONSTRAINT pk_cards 
        unique (card_num),
    CONSTRAINT fk_cards
        FOREIGN KEY (account_num)
        REFERENCES accounts(account_num)
	distributed by randomly
    );
    
create table terminals (
    terminal_id varchar(100),
    terminal_type varchar(100),
    terminal_city varchar(100),
    terminal_address varchar(100),

    CONSTRAINT pk_terminals
        unique (terminal_id)
	distributed by randomly
    );
    

CREATE TABLE transactions (
    trans_id varchar(100),
    trans_date timestamp,
    card_num varchar(100),
    oper_type varchar(100),
    amt decimal(20),
    oper_result varchar(100),
    terminal varchar(100),
    CONSTRAINT card_fk 
        FOREIGN KEY (card_num)
        REFERENCES cards(card_num),
    CONSTRAINT terminal_fk 
        FOREIGN KEY (terminal)
        REFERENCES terminals(terminal_id)
	distributed by (terminal)
    );

drop table if exists dim_clients_hist;
drop table if exists dim_accounts_hist;
drop table if exists dim_cards_hist;
drop table if exists dim_terminals_hist;
drop table if exists dim_transactions_hist;

create table dim_clients_hist (
    client_id varchar(100),
    last_name varchar(100),
    first_name varchar(100),
    patrinymic varchar(100),
    date_of_birth timestamp,
    passport_num varchar(100),
    passport_valid_to timestamp, 
    phone varchar(100),
    start_dt date,
    end_dt date
	distributed by randomly
    );
   
create table dim_accounts_hist  (
    account_num varchar(100),
    valid_to timestamp,	
    client varchar(100),
	start_dt date,
    end_dt date
	distributed by randomly
    );
   
create table dim_cards_hist (
    card_num varchar(100),
    account_num varchar(100),
	start_dt date,
    end_dt date
	distributed by randomly
    );
   
create table dim_terminals_hist (
    terminal_id varchar(100),
    terminal_type varchar(100),
    terminal_city varchar(100),
    terminal_address varchar(100),
	start_dt date,
    end_dt date
	distributed by randomly
    );
   
CREATE TABLE dim_transactions_hist (
    trans_id varchar(100),
    trans_date timestamp,
    card_num varchar(100),
    oper_type varchar(100),
    amt decimal(20),
    oper_result varchar(100),
    terminal varchar(100),
    start_dt date,
    end_dt date
	distributed by randomly
    );
    
   
drop table if exists report;
create table report (
	fraud_dt timestamp,
	passport varchar(100),
	fio varchar(200),
	phone varchar(100),
	fraud_type varchar(200),
	report_dt timestamp
	distributed by randomly
	);
	

drop table fact_transactions;
commit;
create table fact_transactions (
    trans_id varchar(100),
    trans_date timestamp,
    card_num varchar(100),
    account_id varchar(100),
    account_valid_to timestamp,
    client_id varchar(100),
    last_name varchar(100),
    first_name varchar(100),
    patro varchar(100),
    date_of_birth timestamp,
    passport varchar(100),
    passport_valid_to timestamp, 
    phone varchar(100),
    oper_type varchar(100),
    amount numeric(20),
    oper_result varchar(100),
    terminal varchar(100),
    terminal_type varchar(100),
    city varchar(100),
    address varchar(100)
	distributed by randomly
);
commit;