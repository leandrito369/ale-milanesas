-- MR-6: huella normalizada del esquema PostgreSQL tras creación directa o migración.
-- No modifica información. Filtra exclusivamente mr5_validacion.
WITH firmas AS (
 SELECT 'COLUMNA' AS tipo, c.table_name||'.'||c.ordinal_position||'.'||c.column_name AS objeto,
        concat_ws('~',c.udt_name,c.data_type,c.character_maximum_length::text,
                  c.numeric_precision::text,c.numeric_scale::text,c.is_nullable,c.column_default) AS definicion
 FROM information_schema.columns c WHERE c.table_schema='mr5_validacion'
 UNION ALL
 SELECT 'CONSTRAINT',c.conname||'.'||cl.relname,
        c.contype::text||'~'||pg_get_constraintdef(c.oid)
 FROM pg_constraint c
 JOIN pg_namespace n ON n.oid=c.connamespace
 JOIN pg_class cl ON cl.oid=c.conrelid
 WHERE n.nspname='mr5_validacion'
 UNION ALL
 SELECT 'INDICE',i.tablename||'.'||i.indexname,i.indexdef
 FROM pg_indexes i WHERE i.schemaname='mr5_validacion'
 UNION ALL
 SELECT 'TRIGGER',cl.relname||'.'||tg.tgname,pg_get_triggerdef(tg.oid)
 FROM pg_trigger tg
 JOIN pg_class cl ON cl.oid=tg.tgrelid
 JOIN pg_namespace n ON n.oid=cl.relnamespace
 WHERE n.nspname='mr5_validacion' AND NOT tg.tgisinternal
 UNION ALL
 SELECT 'FUNCION',p.proname||'('||pg_get_function_identity_arguments(p.oid)||')',
        md5(pg_get_functiondef(p.oid))
 FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
 WHERE n.nspname='mr5_validacion'
)
SELECT tipo||'|'||objeto||'|'||definicion FROM firmas ORDER BY tipo,objeto,definicion;
