####################################
### Generate SQL Database Scheme ###
####################################
CREATE TABLE patient (
record_id VARCHAR(50) PRIMARY KEY,
external_sample VARCHAR(1),
secondary_id VARCHAR(50),
deceased VARCHAR(1),
vip_flag VARCHAR(1),
last_name TEXT,
sex VARCHAR(1),
num_live_births INTEGER,
date_of_birth DATE,
date_of_death DATE,
init_clinic_location VARCHAR(1)
);
CREATE INDEX [IDX_records_id] ON "patient" ([record_id]);

#Time format = HH:MM
CREATE TABLE blood_draw (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
fk_record_id VARCHAR(50) NOT NULL,
draw_id VARCHAR(50),
draw_date DATE,  
draw_time VARCHAR(5), 
process_date DATE,  
process_time VARCHAR(5), 
total_tubes_received INTEGER,
total_volume_received INTEGER,
num_sodium_heparin_tubes INTEGER,
num_of_edta_tubes INTEGER,
num_whole_blood_tubes INTEGER,
num_streck_tubes INTEGER,
num_acd_tubes INTEGER,
num_other_tubes INTEGER,
processed_plasma_tubes INTEGER,
FOREIGN KEY([fk_record_id]) REFERENCES patient([record_id]) 
);
CREATE INDEX [IDX_draw_id] ON "blood_draw" ([draw_id]);

CREATE TABLE freezer_slot (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
fk_blood_draw_id INTEGER NOT NULL,
freezer VARCHAR(50),
rack VARCHAR(50),
box VARCHAR(50),
box_type VARCHAR(50),
slot INTEGER,
status VARCHAR(50),
store_date DATE,
pulled_date DATE,
frozen_volume INTEGER,
frozen_comments TEXT,
FOREIGN KEY([fk_blood_draw_id]) REFERENCES blood_draw([id]) 
);
CREATE INDEX [IDX_rack] ON "freezer_slot" ([rack]);
CREATE INDEX [IDX_box] ON "freezer_slot" ([box]);


#####################################
###  Populate Demo SQL Database   ###
#####################################
INSERT INTO patient (record_id,external_sample,deceased,vip_flag,last_name,sex,date_of_birth,date_of_death)
VALUES("1000001","N","N","N","Smith","F","1/6/1955","");
INSERT INTO blood_draw (fk_record_id,draw_id,draw_date,process_date,total_tubes_received,num_sodium_heparin_tubes,num_of_edta_tubes)
VALUES("1000001","Tk-1","1/11/2011","1/11/2011",6,4,2);

