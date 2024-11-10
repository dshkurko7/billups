

--===========================================================================
--IMPORTANT!!!
--HERE WE NEED TO UPLOAD DATA FROM CSV FILE USING DATA EXTRACTION APPLICATION
--===========================================================================
--============================
--CREATE DB FOR WORK WITH DATA
--============================


USE [POI]
GO
/****** Object:  Table [dbo].[items]    Script Date: 06.11.2024 13:01:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[items]') AND type in (N'U'))
DROP TABLE [dbo].[items]
GO

/****** Object:  Table [dbo].[cities]    Script Date: 06.11.2024 13:02:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cities]') AND type in (N'U'))
DROP TABLE [dbo].[cities]
GO

/****** Object:  Table [dbo].[brands]    Script Date: 06.11.2024 13:02:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[brands]') AND type in (N'U'))
DROP TABLE [dbo].[brands]
GO

/****** Object:  Table [dbo].[sub_categories]    Script Date: 06.11.2024 13:03:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sub_categories]') AND type in (N'U'))
DROP TABLE [dbo].[sub_categories]
GO

/****** Object:  Table [dbo].[top_categories]    Script Date: 06.11.2024 13:02:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[top_categories]') AND type in (N'U'))
DROP TABLE [dbo].[top_categories]
GO

/****** Object:  Table [dbo].[regions]    Script Date: 06.11.2024 13:03:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[regions]') AND type in (N'U'))
DROP TABLE [dbo].[regions]
GO


USE [POI]
GO
/****** Object:  Table [dbo].[brands]    Script Date: 06.11.2024 13:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[brands](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](150) NOT NULL,
	[unique_id] [nvarchar](250) NULL,
 CONSTRAINT [PK_brands] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[cities]    Script Date: 06.11.2024 13:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cities](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[region_code] [varchar](2) NULL,
	[country_code] [varchar](2) NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_cities] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[cities]  WITH CHECK ADD  CONSTRAINT [FK_cities_cities] FOREIGN KEY([id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[cities] CHECK CONSTRAINT [FK_cities_cities]
GO
/****** Object:  Table [dbo].[top_categories]    Script Date: 06.11.2024 13:04:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[top_categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NULL,
 CONSTRAINT [PK_top_categories] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[sub_categories]    Script Date: 06.11.2024 13:04:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sub_categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[top_category_id] [int] NULL,
	[name] [nvarchar](200) NULL,
 CONSTRAINT [PK_sub_categories] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[sub_categories]  WITH CHECK ADD  CONSTRAINT [FK_sub_categories_sub_categories] FOREIGN KEY([top_category_id])
REFERENCES [dbo].[top_categories] ([id])
GO
ALTER TABLE [dbo].[sub_categories] CHECK CONSTRAINT [FK_sub_categories_sub_categories]
GO

/****** Object:  Table [dbo].[items]    Script Date: 06.11.2024 13:03:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[items](
	[id] [varchar](50) NOT NULL,
	[parent_id] [varchar](50) NULL,
	[brand_id] [int] NULL,
	[sub_category_id] [int] NULL,
	[postal_code] [varchar](10) NULL,
	[location_name] [varchar](250) NULL,
	[latitude] [varchar](50) NULL,
	[longitude] [varchar](50) NULL,
	[city_id] [int] NULL,
	[location]  AS ([geography]::STGeomFromText(((('POINT('+[longitude])+' ')+[latitude])+')',(4326))),
	[operation_hours] [varchar](max) NULL,
	[polygon_wkt] [geography] NULL,
 CONSTRAINT [PK_items] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[items]  WITH CHECK ADD  CONSTRAINT [FK_items_brands] FOREIGN KEY([brand_id])
REFERENCES [dbo].[brands] ([id])
GO
ALTER TABLE [dbo].[items] CHECK CONSTRAINT [FK_items_brands]
GO
ALTER TABLE [dbo].[items]  WITH CHECK ADD  CONSTRAINT [FK_items_cities] FOREIGN KEY([city_id])
REFERENCES [dbo].[cities] ([id])
GO
ALTER TABLE [dbo].[items] CHECK CONSTRAINT [FK_items_cities]
GO
ALTER TABLE [dbo].[items]  WITH CHECK ADD  CONSTRAINT [FK_items_sub_categories] FOREIGN KEY([sub_category_id])
REFERENCES [dbo].[sub_categories] ([id])
GO
ALTER TABLE [dbo].[items] CHECK CONSTRAINT [FK_items_sub_categories]
GO

/****** Object:  Table [dbo].[regions]    Script Date: 06.11.2024 13:04:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[regions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[region_code] [varchar](2) NOT NULL,
	[country_code] [varchar](2) NOT NULL,
 CONSTRAINT [PK_regions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




--=============================================
--TRANSFER DATA TO DB TABLES FROM INITIAL TABLE
--=============================================

delete from items
delete from cities
delete from regions
delete from sub_categories
delete from top_categories
delete from brands

insert into brands (name, unique_id)
select distinct brand, brand_id from phoenix where brand_id is not null order by brand

insert into top_categories (name)
select distinct top_category from phoenix where top_category is not null order by top_category

insert into sub_categories (top_category_id, name)
select distinct tc.id, p.sub_category from phoenix p join top_categories tc on p.top_category=tc.name order by tc.id, p.sub_category

insert into regions (region_code, country_code)
select distinct country_code, region from phoenix where region is not null order by country_code, region

insert into cities (country_code, region_code, name)
select distinct country_code, region, city from phoenix order by country_code, region, city

insert into items (id, parent_id, brand_id, sub_category_id, postal_code, location_name, latitude, longitude, city_id, operation_hours, polygon_wkt)
select p.id, p.parent_id, b.id, sc.id, p.postal_code, p.location_name, p.latitude, p.longitude, c.id, p.operation_hours, p.polygon_wkt
from phoenix p
left join brands b on p.brand_id=b.unique_id
left join top_categories tc on p.top_category=tc.name
left join sub_categories sc on sc.top_category_id=tc.id and p.sub_category=sc.name
left join cities c on p.city=c.name and p.country_code=c.country_code and p.region=c.region_code


--========================================
--CREATE STORED ROCEDUE FOR WORK WITH DATA
--========================================


USE [POI]
GO

--/****** Object:  StoredProcedure [dbo].[usp_PointsOfInterest]    Script Date: 06.11.2024 13:23:09 ******/
--DROP PROCEDURE [dbo].[usp_PointsOfInterest]
--GO

/****** Object:  StoredProcedure [dbo].[usp_PointsOfInterest]    Script Date: 06.11.2024 13:23:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PointsOfInterest]
	@UserJSON NVARCHAR(MAX)
AS
BEGIN
	DECLARE @country VARCHAR(2)
	DECLARE @region VARCHAR(2)
	DECLARE @city VARCHAR(50)
	DECLARE @latitude NVARCHAR(MAX)
	DECLARE @longitude NVARCHAR(MAX)
	DECLARE @radius VARCHAR(10)

	DECLARE @top_category VARCHAR(250)
	DECLARE @sub_category VARCHAR(250)
	DECLARE @name VARCHAR(250)
	DECLARE @area_string NVARCHAR(MAX)

	DECLARE @location geography
	DECLARE @area geography

	SET @country = JSON_VALUE(@UserJson, '$.country')
	SET @region = JSON_VALUE(@UserJson, '$.region')
	SET @city = JSON_VALUE(@UserJson, '$.city')
	SET @latitude = JSON_VALUE(@UserJson, '$.location.latitude')
	SET @longitude = JSON_VALUE(@UserJson, '$.location.longitude')
	SET @radius = JSON_VALUE(@UserJson, '$.location.radius')

	SET @top_category = JSON_VALUE(@UserJson, '$.category.top_category')
	SET @sub_category = JSON_VALUE(@UserJson, '$.category.sub_category')
	SET @name = JSON_VALUE(@UserJson, '$.name')
	SET @area_string = JSON_VALUE(@UserJson, '$.area')
	SET @location = geography::STGeomFromText('POINT('+@longitude+' '+@latitude+')', 4326)

	IF @area_string is not null AND @area_string!=''
		BEGIN
			SET @area =(geography::STGeomFromText(@area_string, 4326))
		END
		ELSE BEGIN
			SET @area = NULL
		END

	SELECT 
    'FeatureCollection' AS type,
    (
        SELECT 
			'Feature' as [type],
			JSON_QUERY('{"type":"Point","coordinates":['+i.longitude+','+i.latitude+']}') as [geometry],
			JSON_QUERY('{"id":"'+i.id+'","parent_id":'+IIF(i.parent_id is null,'null','"'+i.parent_id+'"')+',"country_code":'+IIF(c.country_code is null,'null','"'+c.country_code+'"')+',"region_code":'+IIF(c.region_code is null,'null','"'+c.region_code+'"')+',"city_name":'+IIF(c.name is null,'null','"'+c.name+'"')+',"top_category_name":'+IIF(t.name is null,'null','"'+t.name+'"')+',"sub_category_name":'+IIF(s.name is null,'null','"'+s.name+'"')+',"location_name":'+IIF(i.location_name is null,'null','"'+location_name+'"')+',"operation_hours":'+IIF(i.operation_hours is null,'null',i.operation_hours)+',"polygon_wkt":'+IIF(i.polygon_wkt is null,'null', '"'+i.polygon_wkt.ToString()+'"')+'}') as [properties]
            
		FROM items i 
			LEFT JOIN cities c on i.city_id = c.id
			LEFT JOIN sub_categories s on s.id = i.sub_category_id
			JOIN top_categories t on t.id = s.top_category_id
		WHERE
			(@country is null or @country = '' or c.country_code = @country) AND
			(@region is null or @region = '' or c.region_code = @region) AND
			(@city is null or @city= '' or c.name LIKE '%'+@city+'%') AND
			(@top_category is null or @top_category = '' or t.name LIKE '%'+@top_category+'%') AND
			(@sub_category is null or @sub_category= '' or s.name LIKE '%'+@sub_category+'%') AND
			(@name is null or @name = '' or i.location_name LIKE '%'+@name+'%') AND
			(@location.STDistance(i.location) < @radius) AND
			(@area is null OR @area.STIntersects(location) > 0) --AND
			--i.operation_hours is not null
		ORDER BY @location.STDistance(i.location)
        FOR JSON PATH
    ) AS features
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
GO

