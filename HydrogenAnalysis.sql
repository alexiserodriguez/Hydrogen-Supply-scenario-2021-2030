--Showing the table
SELECT * 
FROM Hydrogen.dbo.hydrogen$

--Getting the projects with Date online from 2021 to the future
SELECT *
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null 
	AND [Date online] >=2021
	AND [Date online] <=2030
ORDER BY [Date online]

--Getting the amount of projects per year
SELECT [Date online], COUNT([Date online]) AS [Number of proyects] 
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null 
	AND [Date online] >=2021
	AND [Date online] <=2030
GROUP BY [Date online]
ORDER BY [Date online]

--Getting ENC in projects in the initial stages per year
WITH initial_stages ([Date online],[ENC Initial])
AS 
	(SELECT 
		[Date online], 
		SUM([IEA zero-carbon ENC]) AS [ENC Initial]
	FROM Hydrogen.dbo.hydrogen$
	WHERE [Date online] is not null 
		AND [Date online] >=2021
		AND [Date online] <=2030
		AND [Status]<>'Under construction'
		AND [Status]<>'Operational'
		AND [Status]<>'FID'
	GROUP BY [Date online]),

--Getting ENC in projects in the final stages per year
final_stages ([Date online],[ENC Final]) 
AS 
	(SELECT 
		[Date online], 
		SUM([IEA zero-carbon ENC]) AS [ENC Final]
	FROM Hydrogen.dbo.hydrogen$
	WHERE [Date online] is not null 
		AND [Date online] >=2021
		AND [Date online] <=2030
		AND [Status]<>'Feasibility study'
		AND [Status]<>'Concept'
		AND [Status]<>'DEMO'
	GROUP BY [Date online])

--Getting ENC of projects in Initial and final Stages per year
SELECT initial_stages.[Date online], initial_stages.[ENC Initial], final_stages.[ENC Final]
FROM initial_stages
FULL OUTER JOIN final_stages
ON initial_stages.[Date online]=final_stages.[Date online]

--Getting ENC of Hydrogen supply per technology

WITH electrolysis 
AS 
	(SELECT 
		[Date online], 
		SUM([IEA zero-carbon ENC]) AS [ENC Electrolysis]
	FROM Hydrogen.dbo.hydrogen$
	WHERE [Date online] is not null 
		AND [Date online] >=2021
		AND [Date online] <=2030
		AND [Status]<>'Feasibility study'
		AND [Status]<>'Concept'
		AND [Status]<>'DEMO'
		AND([Technology]='PEM'
		OR [Technology]='ALK'
		OR [Technology]='SOEC'
		OR [Technology]='Other Electrolysis')
	GROUP BY [Date online]),

fossil_dioxide
AS
	(SELECT 
		[Date online], 
		SUM([IEA zero-carbon ENC]) AS [ENC Fossil Dioxide]
	FROM Hydrogen.dbo.hydrogen$
	WHERE [Date online] is not null 
		AND [Date online] >=2021
		AND [Date online] <=2030
		AND [Status]<>'Feasibility study'
		AND [Status]<>'Concept'
		AND [Status]<>'DEMO'
		AND([Technology]='Coal w CCUS'
		OR [Technology]='NG w CCUS')
	GROUP BY [Date online]),
biomass
AS
	(SELECT 
		[Date online], 
		SUM([IEA zero-carbon ENC]) AS [ENC Biomass]
	FROM Hydrogen.dbo.hydrogen$
	WHERE [Date online] is not null 
		AND [Date online] >=2021
		AND [Date online] <=2030
		AND [Status]<>'Feasibility study'
		AND [Status]<>'Concept'
		AND [Status]<>'DEMO'
		AND([Technology]='Biomass')
	GROUP BY [Date online])

SELECT electrolysis.[Date online], electrolysis.[ENC Electrolysis], fossil_dioxide.[ENC Fossil Dioxide], biomass.[ENC Biomass]
FROM electrolysis
FULL OUTER JOIN fossil_dioxide
ON electrolysis.[Date online]=fossil_dioxide.[Date online]
FULL OUTER JOIN biomass
ON electrolysis.[Date online]=biomass.[Date online]

--Getting the amount of projects and Electrical Normalized Capacity (ENC) per country at final stages
SELECT [Country], COUNT([Country]) AS [Number of proyects], SUM([IEA zero-carbon ENC]) AS [ENC]
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null
	AND [Country] is not null
	AND [Date online] >=2021
	AND [Date online] <=2030
	AND [Status]<>'Feasibility study'
	AND [Status]<>'Concept'
	AND [Status]<>'DEMO'
GROUP BY [Country]
ORDER BY [ENC] DESC

--Getting  the amount of projects per End Product
SELECT [Product], COUNT([Product]) AS [Number of proyects]
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null
	AND [Country] is not null
	AND [Date online] >=2021
	AND [Date online] <=2030
	AND [Status]<>'Feasibility study'
	AND [Status]<>'Concept'
	AND [Status]<>'DEMO'
	AND [Product] is not null
GROUP BY [Product]

--Getting the amount of projects per End-use sector
SELECT [Date online], 
	COUNT([Date online]) AS [Year], 
	SUM(CAST([Refining] AS int)) As [Refining],
	SUM(CAST([Ammonia] AS int)) As [Ammonia],
	SUM(CAST([Methanol] AS int)) As [Methanol],
	SUM(CAST([Iron&Steel] AS int)) As [Iron&Steel],
	SUM(CAST([Other Ind] AS int)) As [Other Ind],
	SUM(CAST([Mobility] AS int)) As [Mobility],
	SUM(CAST([Power] AS int)) As [Power],
	SUM(CAST([Grid inj#] AS int)) As [Grid inj#],
	SUM(CAST([CHP] AS int)) As [CHP],
	SUM(CAST([Domestic heat] AS int)) As [Domestic heat],
	SUM(CAST([Biofuels] AS int)) As [Biofuels],
	SUM(CAST([Synfuels] AS int)) As [Synfuels],
	SUM(CAST([CH4 grid inj#] AS int)) As [CH4 grid inj#],
	SUM(CAST([CH4 mobility] AS int)) As [CH4 mobility]
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null 
	AND [Date online] >=2021
	AND [Date online] <=2030
	AND [Status]<>'Feasibility study'
	AND [Status]<>'Concept'
	AND [Status]<>'DEMO'
GROUP BY [Date online]
ORDER BY [Date online]

--Getting ENC per technology
SELECT [Technology], SUM([IEA zero-carbon ENC]) AS [ENC]
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null
	AND [Country] is not null
	AND [Date online] >=2021
	AND [Date online] <=2030
	AND [Status]<>'Feasibility study'
	AND [Status]<>'Concept'
	AND [Status]<>'DEMO'
GROUP BY [Technology]
ORDER BY [ENC] DESC

--Getting ENC per type of renewable to supply
SELECT [Type of renewable], SUM([IEA zero-carbon ENC]) AS [ENC]
FROM Hydrogen.dbo.hydrogen$
WHERE [Date online] is not null
	AND [Country] is not null
	AND [Date online] >=2021
	AND [Date online] <=2030
	AND [Status]<>'Feasibility study'
	AND [Status]<>'Concept'
	AND [Status]<>'DEMO'
	AND [Type of renewable] is not null
GROUP BY [Type of renewable]
ORDER BY [ENC] DESC