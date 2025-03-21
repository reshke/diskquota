-- Test delete disk quota
CREATE SCHEMA deleteschema;
SELECT diskquota.set_schema_quota('deleteschema', '1 MB');
SET search_path TO deleteschema;

CREATE TABLE c (i INT);
-- expect failed 
INSERT INTO c SELECT generate_series(1,100000);
SELECT diskquota.wait_for_worker_new_epoch();
-- expect fail
INSERT INTO c SELECT generate_series(1,100);
SELECT diskquota.set_schema_quota('deleteschema', '-1 MB');
SELECT diskquota.wait_for_worker_new_epoch();

INSERT INTO c SELECT generate_series(1,100);

DROP TABLE c;
RESET search_path;
DROP SCHEMA deleteschema;
