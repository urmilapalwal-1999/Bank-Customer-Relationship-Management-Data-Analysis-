-- ----------------BANK_CRM_POWERBI_PROJECT--------------------------

select
bc.CustomerId,
ci.Surname,
ci.Age,
gn.GenderCategory,
g.GeographyLocation,
ci.EstimatedSalary,
bc.NumOfProducts,
bc.Tenure,
bc.Balance,
bc.CreditScore,
bc.HasCrCard,
bc.IsActiveMember,
bc.Exited
from bank_churn bc
join customerinfo ci
on bc.CustomerId = ci.CustomerId
join geography g 
on g.GeographyID=ci.GeographyID
join gender gn 
on gn.GenderID=ci.GenderID;

Create table  MainTable as 

select
bc.CustomerId,
ci.Surname,
ci.Age,
gn.GenderCategory,
g.GeographyLocation,
ci.EstimatedSalary,
bc.NumOfProducts,
bc.Tenure,
bc.Balance,
bc.CreditScore,
bc.HasCrCard,
bc.IsActiveMember,
bc.Exited
from bank_churn bc
join customerinfo ci
on bc.CustomerId = ci.CustomerId
join geography g 
on g.GeographyID=ci.GeographyID
join gender gn 
on gn.GenderID=ci.GenderID; 

-- ------------------ Ojective Questions ----------------
-- 2.Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)

select 
CustomerId, Surname, 
EstimatedSalary
from customerinfo
Order by EstimatedSalary desc
limit 5;

-- 3.Calculate the average number of products used by customers who have a credit card. (SQL)

select 
avg(NumOfProducts) as avg_products
from bank_churn
where HasCrCard = 1;

-- 4 .Determine the churn rate by gender for the most recent year in the dataset.

select 
GenderCategory,
round(sum(Exited)*100/count(*),2) as churn_rate_percentage
from customerinfo ci 
join bank_churn bc
on ci.CustomerId = bc.CustomerId
join gender g 
on g.GenderID=ci.GenderID
where year(`Bank DOJ`) = (select year(max(`Bank DOJ`)) from customerinfo) 
group by GenderCategory;

SELECT
	GenderCategory,
    ROUND(SUM(Exited) * 100 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM customer_info a
JOIN bank_churn b ON a.CustomerID = b.CustomerID
JOIN gender c ON a.GenderID = c.GenderID
WHERE YEAR(`Bank DOJ`) = (SELECT YEAR(MAX(`Bank DOJ`)) FROM customer_info)
GROUP BY GenderCategory;
 



-- 5.Compare the average credit score of customers who have exited and those who remain. (SQL)

select
Exited,
avg(CreditScore) as avg_credit_score
from bank_churn
group by Exited;

-- 6.Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)

select
g.GenderCategory,
round(avg(ci.EstimatedSalary),2) as avg_est_salary,
sum(bc.IsActiveMember) as total_active_accounts
from customerinfo ci
join gender g 
on g.GenderID=ci.GenderID
join bank_churn bc 
on bc.CustomerId=ci.CustomerId
group by g.GenderCategory;

-- 7.Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)

select 
case 
when CreditScore < 500 then "Low Credit Score"
when CreditScore between 500 and 700 then "Medium Credit Score"
else "High Credit Score"
end as credit_segment,
count(CustomerId) as total_customer,
round(sum(Exited) * 100 / count(*),2) as exit_rate_percentage
from bank_churn
group by credit_segment
order by exit_rate_percentage desc;

-- 8.Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)

with active_customer_table as 
(Select
GeographyLocation,
ci.CustomerId,
case when Exited=1 then 0
else IsActiveMember
end as actuall_active_member
from customerinfo ci 
join geography g 
on g.GeographyID=ci.GeographyID
join bank_churn bc 
on bc.CustomerId=ci.CustomerId
where Tenure > 5
having actuall_active_member = 1)

select
GeographyLocation,
count(CustomerID) as active_customer
from active_customer_table
group by GeographyLocation;



-- 15.Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. Also, rank the gender according to the average value. (SQL)

select
g.GeographyID,
GeographyLocation,
GenderCategory,
round(avg(EstimatedSalary),2) as avg_salary,
rank()over(partition by GeographyID order by round(avg(EstimatedSalary),2) desc) as Gender_rank
from  customerinfo ci
join geography g
on ci.GeographyID=g.GeographyID
join gender ge 
on ge.GenderID=ci.GenderID
group by g.GeographyID,
GeographyLocation,
GenderCategory;

-- 16.Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

select
case 
when age between 18 and 30 then "18-30"
when age between 31 and 50 then "30-50"
else "50+" end as age_bucket,
round(avg(Tenure),2) as avg_tenure
from customerinfo ci 
join bank_churn bc 
on ci.CustomerId=bc.CustomerId
where Exited=1
group by age_bucket;

-- 20.According to the age buckets find the number of customers who have a credit card. Also retrieve those buckets that have lesser than average number of credit cards per bucket.

with age_bucket as 
(select 
case 
when age between 18 and 30 then "18-30"
when age between 31 and 50 then "30-50"
else "50+"
end as age_bucket,
count(*) as creditcard_customers
from customerinfo c 
join bank_churn b 
on c.CustomerId=b.CustomerId
where HasCrCard = 1 
group by age_bucket)

select 
*
from age_bucket 
where creditcard_customers <(select avg(creditcard_customers * 1.0) from age_bucket);

-- 23.Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.ExitCategory

select 
*,
(select ExitCategory from exitcustomer e where bc.Exited=e.ExitID) as ExitCategory
from bank_churn bc;

-- 25.Write the query to get the customer IDs, their last name, and whether they are active or not for the customers whose surname ends with “on”.

SELECT
c.CustomerID, 
Surname, 
ActiveCategory
FROM customerinfo c
JOIN bank_churn b ON c.CustomerID = b.CustomerID
JOIN activecustomer a ON a.ActiveID = b.IsActiveMember
WHERE Surname LIKE '%on';

-- Q.26. Can you observe any data disrupency in the Customer’s data? As a hint it’s present in the IsActiveMember and Exited columns. One more point to consider is that the data in the Exited Column is absolutely correct and accurate.

SELECT 
CustomerId,
IsActiveMember,
Exited
FROM Bank_Churn
WHERE IsActiveMember = 1
AND Exited = 1;




-- --------------------Subjectives----------------------------------
-- Q.9. Utilize SQL queries to segment customers based on demographics and account details.

Select
case 
when Age between 18 and 30 then "Young Customers"
when Age between 31 and 50 then "Middle Age Customers"
else "Senior Customers"
end as age_segment,
case 
when Balance <50000 then "Low balance"
when Balance between 50000 and 150000 then "Medium Balance"
else "High balance"
end as balance_segment,
case 
when CreditScore < 500 then "Low Credit Score"
when CreditScore between 500 and 700 then "Medium Credit Score"
else "High Credit Score"
end as CreditScore_segment,
count(c.CustomerId) as total_customers
from customerinfo c 
join bank_churn b 
on c.CustomerId=b.CustomerId
group by age_segment,balance_segment, CreditScore_segment
order by total_customers desc;


-- Q.14. In the “Bank_Churn” table how can you modify the name of the “HasCrCard” column to “Has_creditcard”?

alter table bank_churn
rename column  HasCrCard to Has_creditcard;

-- -- (Run the below query to get the original column name back, as all the other above queries utilises the original column name)

ALTER TABLE bank_churn 
RENAME COLUMN Has_CreditCard TO HasCrCard;