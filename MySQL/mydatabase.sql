USE mydatabase;
CREATE INDEX men_hash USING HASH ON tab_memory (city_id);