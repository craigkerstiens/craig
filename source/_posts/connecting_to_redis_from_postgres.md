

    git clone git://github.com/antirez/hiredis.git
    cd hiredis
    make 
    sudo make install


    PATH=/Applications/Postgres.app/Contents/MacOS/bin/:$PATH USE_PGXS=1 make
    sudo PATH=/Applications/Postgres.app/Contents/MacOS/bin/:$PATH USE_PGXS=1 make install
    
    psql
    CREATE EXTENSION redis_fdw;

    CREATE SERVER redis_server 
		FOREIGN DATA WRAPPER redis_fdw 
		OPTIONS (address '127.0.0.1', port '6379');

	CREATE FOREIGN TABLE redis_db0 (key text, value text) 
		SERVER redis_server
		OPTIONS (database '0');

	CREATE USER MAPPING FOR PUBLIC
		SERVER redis_server
		OPTIONS (password 'secret');