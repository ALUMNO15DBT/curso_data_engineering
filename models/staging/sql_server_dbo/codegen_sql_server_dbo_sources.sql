{{
    codegen._src_sql_server_dbo.yml(
        schema_name = 'sql_server_dbo',
        database_name = 'ALUMNO15_DEV_BRONZE_DB',
        table_names = ['addresses','orders','events','products','promos','users','order_items'],
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        name='desarrollo',
        include_database=True,
        include_schema=True
        )
}}