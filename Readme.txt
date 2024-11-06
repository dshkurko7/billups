This assembly is a set of files for implementing the technical task for searching the "Points of Interest" by geographic coordinates and other details.
The assembly implements the ETL technology for processing data from structured and unstructured sources. In our case, the source of data will be a .csv file.

Data processing will be performed in three stages:

1. Extract - the stage at which "raw" data is extracted from the file into a specially created DB table. There are several ways of such extraction. These can be SSIS tools, it can be a Python application using Pandas tools, or it can be a Logstash. In our case, a console application was written in C#...
In many ways, this application implements the work of the data import wizard available in Microsoft Management Studio.
To perform this stage of work, you need to run the importer application.
Thus, the data from the .csv file was imported into the DB table for subsequent processing

2. Transform - at this stage, the data is structured as relational DB data and filtering, sorting or selecting the necessary ones is performed on them.
In our case, the data is "scattered" across the relational DB tables (the database schema is attached), after which the data can be processed using a specially created stored procedure (the script for creating the procedure is included in the DB schema)

3. Load - at this stage, the data can be loaded somewhere for use. For example, into any application or accepted by any DB. In our case, the stored procedure receives input parameters in the JSON format and returns the result in the GeoJSON format. I assume that data in this format can be used, for example, in navigation applications.

Step-by-step instructions
1. The computer must have MSSQL EXPRESS 19 with Microsoft Management Studio installed.
2. Run the POI_DB_create script.

3. Run the importer application:
	
	Run cmd in PhoenixImport folder
	Execute commands:
    >dotnet publish
    >cd bin\Release\net8.0
    >PhoenixImport.exe "C:\Temp\phoenix.csv" "Server=DESKTOP-43T6PR8\SQLEXPRESS;Database=POI;User Id=iis;Password=P@ssw0rd; TrustServerCertificate=True;" "phoenix"
	where:
    path-to-csv-file: "C:\Temp\phoenix.csv"
    connection-string "Server=DESKTOP-43T6PR8\SQLEXPRESS;Database=POI;User Id=iis;Password=P@ssw0rd; TrustServerCertificate=True;"
    destination-table-name: "phoenix"

	Wait for few minutes.

4. Run the POI_DB_schema script.
5. Run the phoenix_geo_function_WorkExample script, entering the desired search parameters.
6. The result can be viewed in Microsoft Management Studio or any text editor.