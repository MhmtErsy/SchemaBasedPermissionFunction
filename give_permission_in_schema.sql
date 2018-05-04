CREATE OR REPLACE
function give_permission(_per text,_from text, _to text, _table_name text)
  returns void
language plpgsql
as $$
DECLARE r RECORD;
 q text;
 t TEXT;
 v_cursor1 CURSOR IS SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_schema=_from;
 v_cursor2 CURSOR IS SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_schema=_from AND table_name=_table_name;
 
BEGIN
	IF _table_name = NULL OR _table_name = '' THEN
            raise notice '< % > Semasindaki tum tablolar için < % > kullanıcısına < % > yetkileri veriliyor..',_from,_to,_per;
			FOR r IN v_cursor1
    		LOOP
        	t:=_from||'.'||r.table_name;
       		q:='grant '||_per||' on '|| t ||' to '|| _to ||';';
	    	execute q;
            raise notice '%',q;
    		END LOOP;
		
    ELSEIF _table_name IS NOT NULL THEN
    
			raise notice '< % > Semasindaki < % > Tablosuna < % > kullanıcısı icin < % > yetkileri veriliyor..',_from,_table_name,_to,_per;
			FOR r IN v_cursor2
    		LOOP
        	t:=_from||'.'||r.table_name;
       		q:='grant '|| _per ||' on '|| t ||' to '|| _to ||';';
	    	execute q;
            raise notice '%',q;
    		END LOOP;
			
    END IF;
END;

$$;
