#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import cx_Oracle
import psycopg2
import sys


conn = psycopg2.connect(dbname='feodor', user='feodor', 
                        password=passwd, host='192.168.1.22')
cursor = conn.cursor()

for i, arg in enumerate(sys.argv):
	if i != 0:
		print (i,arg)
		df = pd.read_excel(arg, converters={'phone':str,'passport':str,'passport_valid_to':str,'date_of_birth':str,'amount':str}).dropna()

		for i in df.values.tolist():
		    buffer = (f"""insert into fact_transactions (trans_id, trans_date, card_num, account_id, account_valid_to,
		    client_id, last_name, first_name, patro, date_of_birth, passport, passport_valid_to,
		    phone, oper_type, amount, oper_result, terminal, terminal_type, city, address)
		    values ('{i[0]}', to_timestamp('{i[1]}','yyyy-mm-dd hh24:mi:ss'), '{i[2]}', '{i[3]}', to_timestamp('{i[4]}','yyyy-mm-dd hh24:mi:ss'),
		    '{i[5]}', '{i[6]}', '{i[7]}', '{i[8]}', to_timestamp('{i[9]}','yyyy-mm-dd hh24:mi:ss'), '{i[10]}', to_timestamp('{i[11]}','yyyy-mm-dd hh24:mi:ss'),
		    '{i[12]}', '{i[13]}', '{i[14]}', '{i[15]}', '{i[16]}', '{i[17]}', '{i[18]}', '{i[19]}')""")
		    cursor.execute(buffer)

conn.commit()
conn.close()

