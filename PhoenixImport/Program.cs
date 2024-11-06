using CsvHelper;
using CsvHelper.Configuration.Attributes;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Reflection;

namespace PhoenixImport
{
    internal class Program
    {
        static void Main(string[] args)
        {
            if(args.Length < 3)
            {
                Console.WriteLine("Usage: PhoenixImport.exe <path-to-csv-file> <connection-string> <table-name>");
                return;
            }

            using (var reader = new StreamReader(args[0]))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            using (var conn = new SqlConnection(args[1]))
            using(var cmd = new SqlCommand() { Connection = conn })
            {
                conn.Open();
                var tableSql = GetCreateTableSql(args[2]);
                foreach (var sql in tableSql)
                {
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                }

                csv.Read();
                csv.ReadHeader();
                var n = 0;
                while (csv.Read())
                {
                    var rec = csv.GetRecord<Record>();
                    var sql = rec.GetSql(args[2]);
                    n++;
                    try
                    {
                        cmd.CommandText = sql;
                        cmd.ExecuteNonQuery();
                        //Console.WriteLine($"{rec.LocationName}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"ERROR {n} {rec.LocationName}: {ex.Message}");
                    }
                }

                conn.Close();
            }
        }

        private static string[] GetCreateTableSql(string tablename)
        {
            return new[]
            {
                $"IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{tablename}]') AND type in (N'U')) DROP TABLE [dbo].[{tablename}]",
                $"CREATE TABLE [dbo].[{tablename}]([id] [varchar](50) NOT NULL,[parent_id] [varchar](50) NULL,[brand] [varchar](200) NULL,[brand_id] [varchar](500) NULL,[top_category] [varchar](200) NULL,[sub_category] [varchar](200) NULL,[category_tags] [varchar](200) NULL,[postal_code] [varchar](10) NULL,[location_name] [varchar](250) NULL,[latitude] [varchar](50) NULL,[longitude] [varchar](50) NULL,[country_code] [varchar](2) NULL,[city] [varchar](50) NULL,[region] [varchar](2) NULL,[operation_hours] [text] NULL,[geometry_type] [varchar](50) NULL,[polygon_wkt] [geography] NULL,CONSTRAINT [PK_{tablename}] PRIMARY KEY CLUSTERED ([id] ASC))"
            };
        }
    }

    internal class Record
    {
        [Name("id")]
        public string Id { get; set; }
        [Name("parent_id")]
        public string ParentId { get; set; }
        [Name("brand")]
        public string Brand { get; set; }
        [Name("brand_id")]
        public string BrandId { get; set; }
        [Name("top_category")]
        public string TopCategory { get; set; }
        [Name("sub_category")] 
        public string SubCategory { get; set; }
        [Name("category_tags")]
        public string CategoryTags { get; set; }
        [Name("postal_code")]
        public string PostalCode { get; set; }
        [Name("location_name")]
        public string LocationName { get; set; }
        [Name("latitude")]
        public string Latitude { get; set; }
        [Name("longitude")]
        public string Longitude { get; set; }
        [Name("country_code")]
        public string CountryCode { get; set; }
        [Name("city")]
        public string City { get; set; }
        [Name("region")]
        public string Region { get; set; }
        [Name("operation_hours")]
        public string OperationHours { get; set; }
        [Name("geometry_type")]
        public string GeometryType { get; set; }
        [Name("polygon_wkt")]
        public string PolygonWkt { get; set; }

        public string GetSql(string table)
        {
            var props = typeof(Record).GetProperties();
            var names = new List<string>();
            var vals = new List<string>();
            foreach(var prop in props)
            {
                var attr = prop.GetCustomAttribute(typeof(NameAttribute), true) as NameAttribute;
                names.Add($"[{attr.Names[0]}]");

                var val = prop.GetValue(this)?.ToString();
                if (string.IsNullOrEmpty(val))
                    vals.Add("NULL");
                else if (prop.Name == nameof(Record.PolygonWkt))
                    vals.Add($"geography::STGeomFromText('{val}',4326)");
                else
                    vals.Add($"'{val.Replace("'", "''")}'");
            }

            return $"INSERT INTO [{table}]({string.Join(',', names)}) VALUES({string.Join(',', vals)})";
        }
    }
}
