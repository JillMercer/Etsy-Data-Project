select *
From [dbo].[TotalEtsyOrders];

Select Sum(Quantity), [Ship City]
From [dbo].[TotalEtsyOrders]


--Find the Cities with the highest quantity ordered
Select [Ship State], [Ship City], Sum(Quantity) as TotalItems, Sum([Item Total]) as TotalPaid
From [dbo].[TotalEtsyOrders]
Group by [Ship City], [Ship State]
Order by TotalPaid Desc

--Find the States with the highest quantity ordered
Select [Ship State], Sum(Quantity) as TotalItems, Sum([Item Total]) as TotalPaid
From [dbo].[TotalEtsyOrders]
Group by [Ship State]
Order by TotalItems Desc

--Most popular products
Select [Item Name], Sum(Quantity) as TotalItems
From [dbo].[TotalEtsyOrders]
Group by [Item Name]
Order by TotalItems Desc

--Most popular coupon 
Select [Coupon Code], Sum(Quantity) as TotalItems
From [dbo].[TotalEtsyOrders]
Where [Coupon Code] is NOT NULL
Group by [Coupon Code]
Order by TotalItems Desc

--Total Days Till Item was shipped
Select [Item Name], [Sale Date], [Date Shipped], Datediff(Day,[Sale Date],[Date Shipped]) as DaysTillShipped
From [dbo].[TotalEtsyOrders]

Drop view [dbo].[shippingTime]


--Total Items sold Each Month
Select Datename(Month,[Sale Date]) as Month, Year([Sale Date]) as Year, Sum(Quantity) as TotalItems, Sum([Item Total]) as TotalPaid
From [dbo].[TotalEtsyOrders]
Group by Year([Sale Date]),Datename(Month,[Sale Date])
Order by TotalItems Desc

--Avg number of days until items are shipped (finds lead time)
Select [Item Name], AVG(Datediff(Day,[Sale Date],[Date Shipped])) as DaysTillShipped
From [dbo].[TotalEtsyOrders]
Group by [Item Name]
Order by [DaysTillShipped] DESC


Select [Ship State], [Ship City], Sum(Quantity) as TotalItems
From [dbo].[TotalEtsyOrders]
Group by [Ship City], [Ship State]
Having [Ship State] = 'FL'
Order by TotalItems Desc

--Most Popular Item Each Month
With Sales (Month, Year, TotalItems,TotalPaid, [Item Name], Rank)
as
(
Select Datename(Month,[Sale Date]) as Month, Year([Sale Date]) as Year, Sum(Quantity) as TotalItems, Sum([Item Total]) as TotalPaid, [Item Name], Rank() OVER (Partition BY Datename(Month,[Sale Date]),Year([Sale Date]) Order by Sum([Item Total]) Desc) as Rank
From [dbo].[TotalEtsyOrders]
Group by Datename(Month,[Sale Date]), Year([Sale Date]),[Item Name]
)

Select *
From Sales
Where Rank = 1
Order by TotalItems Desc

--Average Order Value per Month
Select Datename(Month,[Sale Date]) as Month,  Year([Sale Date]) as Year, Round(Avg([Item Total]),2) as AvgOrderTotal
From [dbo].[TotalEtsyOrders]
Group by Datename(Month,[Sale Date]),  Year([Sale Date])

--Customers that have purchased multiple items
Select Buyer, Sum(Quantity) as TotalItems, Sum([Item Total]) as TotalPrice
From [dbo].[TotalEtsyOrders]
Where Buyer is NOT NULL 
Group by Buyer
Having Sum([Quantity])>1
Order by Sum(Quantity) Desc







