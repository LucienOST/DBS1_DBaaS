CREATE TABLE warehouse(
    w_id SERIAL PRIMARY KEY,
    w_name TEXT NOT NULL,
    w_street TEXT NOT NULL,
    w_city TEXT NOT NULL,
    w_zip INTEGER CHECK(w_zip BETWEEN 1000 AND 9999)
);

CREATE TABLE district(
    d_id SERIAL PRIMARY KEY,
    d_w_id INTEGER, --FK
    d_name TEXT NOT NULL,
    d_street TEXT NOT NULL,
    d_city TEXT NOT NULL,
    d_zip INT CHECK(d_zip BETWEEN 1000 AND 9999),
    CONSTRAINT FK_warehouse FOREIGN KEY (d_w_id) REFERENCES warehouse(w_id)    
);

CREATE TABLE customer(
    c_id SERIAL PRIMARY KEY,
    c_w_id INTEGER, --FK
    c_d_id INTEGER, --FK
    c_first_name TEXT NOT NULL,
    c_last_name TEXT NOT NULL,
    c_street TEXT NOT NULL,
    c_city TEXT NOT NULL,
    c_zip INT CHECK(c_zip BETWEEN 1000 AND 9999),
    c_phone TEXT,
    c_since DATE NOT NULL,
    c_limit NUMERIC (12,2),
    c_discount NUMERIC (4,2),
    c_balance NUMERIC (12,2),
    CONSTRAINT FK_warehouse FOREIGN KEY (c_w_id) REFERENCES warehouse(w_id),
    CONSTRAINT FK_district FOREIGN KEY (c_d_id) REFERENCES district(d_id)       
);

CREATE TABLE item(
    i_id SERIAL PRIMARY KEY,
    i_name TEXT,
    i_price NUMERIC (5,2),
    i_data TEXT,
    i_o_cnt INTEGER
);

CREATE TABLE stock(
    s_i_id INTEGER,
    s_w_id INTEGER,
    s_quantity NUMERIC(4),
    CONSTRAINT FK_warehous FOREIGN KEY (s_w_id) REFERENCES warehouse(w_id),
    CONSTRAINT FK_item FOREIGN KEY (s_i_id) REFERENCES item(i_id) -- Here there would be an additional constraint the tuple w_id and i_id is unique, however, for simplicity reasons it is omitted
);

CREATE TABLE orders( 
    o_id SERIAL PRIMARY KEY,
    o_d_id INTEGER, --FK
    o_w_id INTEGER, --FK
    o_c_id INTEGER, --FK
	o_i_id INTEGER, --FK
	o_quantity INTEGER NOT NULL,
    o_entry_d DATE NOT NULL,
    CONSTRAINT FK_warehoue FOREIGN KEY (o_w_id) REFERENCES warehouse(w_id),
    CONSTRAINT FK_district FOREIGN KEY (o_d_id) REFERENCES district(d_id),
    CONSTRAINT FK_customer FOREIGN KEY (o_c_id) REFERENCES customer(c_id),
	CONSTRAINT FK_item FOREIGN KEY (o_i_id) REFERENCES item(i_id)
);
CREATE TABLE new_order (
    no_w_id INTEGER NOT NULL,
    no_o_id INTEGER NOT NULL,
    no_d_id INTEGER NOT NULL,

    CONSTRAINT PK_new_order_i1 PRIMARY KEY (no_w_id, no_d_id, no_o_id)
);

CREATE TABLE order_line (
    ol_delivery_d TIMESTAMP WITH TIME ZONE,
    ol_o_id INTEGER NOT NULL,
    ol_w_id INTEGER NOT NULL,
    ol_i_id INTEGER NOT NULL,
    ol_supply_w_id INTEGER NOT NULL,
    ol_d_id INTEGER NOT NULL,
    ol_number INTEGER NOT NULL,
    ol_quantity INTEGER NOT NULL,
    ol_amount NUMERIC(6,2),
    ol_dist_info TEXT,

    CONSTRAINT order_line_i1 PRIMARY KEY (ol_w_id, ol_d_id, ol_o_id, ol_number)
);
CREATE TABLE history (
    h_date TIMESTAMP WITH TIME NOT NULL,
    h_c_id INTEGER,
    h_c_w_id INTEGER NOT NULL,
    h_w_id INTEGER NOT NULL,
    h_c_d_id INTEGER NOT NULL,
    h_d_id INTEGER NOT NULL,
    h_amount NUMERIC(6,2) NOT NULL,
    h_data TEXT NOT NULL
);
