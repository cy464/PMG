create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);


create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);

--1. Write a query to get the sum of impressions by day.
SELECT  CONVERT(DATE, [date]) AS Date
    , SUM([Impressions]) AS Daily_Impressions
FROM dbo.Marketing_Performance
GROUP BY [date]
ORDER BY [date]
-- I have [ ] because I dragged the column name straight from the directory, which is faster and more accurate than typing.

-- 2. Write a query to get the top three revenue-generating states in order of best to worst.
SELECT TOP 3 [state]
    , SUM([Revenue]) AS Total_Revenue
FROM dbo.Website_Revenue
GROUP BY [state]
ORDER BY Total_Revenue DESC

-- How much revenue did the third best state generate?
-- The third revenue-generating state is Ohio, and it generated $37577.

--3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign.
-- Make sure to include the campaign name in the output.
SELECT c.[name] AS Campaign_Name --Renaming all these columns
    , m.[campaign_id]
    , ROUND(SUM(m.[cost]),2) AS Total_Cost --Only want 2 decimal places
    , SUM(m.[impressions]) AS Total_Impressions
    , SUM(m.[clicks]) AS Total_Clicks
    , SUM(w.[revenue]) AS Total_Revenue
FROM dbo.marketing_performance m --Renaming the csv files bc their names are too long.
INNER JOIN dbo.campaign_info c
ON m.[campaign_id]=c.[id]  -- Joining these 2 files first
INNER JOIN dbo.website_revenue w
ON m.[campaign_id]=w.[campaign_id] -- Then joining the joint file with the third file
GROUP BY c.[name], m.[campaign_id]
ORDER BY c.[name]



-- 4. Write a query to get the number of conversions of Campaign5 by state.
-- Which state generated the most conversions for this campaign?
SELECT c.[name] AS Campaign
    , SUM(m.[conversions]) AS Total_Conversions --Summing up number of conversions
    , m.[geo] AS State
FROM dbo.campaign_info c
INNER JOIN dbo.marketing_performance m
ON c.[id] = m.[campaign_id]
WHERE c.[name] = 'Campaign5' --filtering just for conversions in Campaign 5
GROUP BY m.[geo]
        ,c.[name]

-- Georgia generated the most conversoins for Campaign 5


5. In your opinion, which campaign was the most efficient, and why?
SELECT c.[name] AS Campaign
    , SUM(m.[conversions]) AS Total_Conversions --Summing up number of conversions
FROM dbo.campaign_info c
INNER JOIN dbo.marketing_performance m
ON c.[id] = m.[campaign_id]
GROUP BY c.[name]
ORDER BY SUM(m.[conversions]) DESC

-- Campaign 3 seems to be the most effective overall because it has the highest sum of conversions across states.


**Bonus Question**

6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
*/
SELECT DATEPART(WEEKDAY, [date]) 'AS Day of the Week'  -- Drawing out the days of the week, according to the date
    , AVG([cost]/[conversions]) AS 'Dollars Per Conversion' -- Finding out how much each conversion costs.
FROM dbo.marketing_performance
GROUP BY DATEPART(WEEKDAY, [date])
ORDER BY AVG([cost]/[conversions]) ASC

-- Wednesday, the 4th day of the week, is the best day to run ads as it has the lowest cost per conversion.
-- I chose to compute the cost per conversion instead of cost per impression because it's more substantial and leads to real results