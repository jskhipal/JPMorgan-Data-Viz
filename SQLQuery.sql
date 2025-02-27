use jaspaldb

UPDATE jpmorgan
SET Transaction_Amount = ROUND(Transaction_Amount, 0);

--Retrieve all columns from the jpmorgan table.

select * from jpmorgan

--Select unique Account_Type values from the table.

select Account_Type
from jpmorgan
group by Account_Type

--Count the total number of transactions.

select count(Transaction_ID) as Total_number_of_Transaction
from jpmorgan

--Retrieve all transactions where Currency is USD.

select *
from jpmorgan
where Currency = 'USD'

--Find transactions with Transaction_Amount greater than 5000.

select * 
from jpmorgan
where Transaction_Amount > 5000;

--Order transactions by Transaction_Amount in descending order.

select *
from jpmorgan
order by Transaction_Amount desc

--Select all transactions that occurred in Houston, TX.

select *
from jpmorgan
where Bank_Branch = 'Houston, TX'

--Find the maximum Transaction_Amount in the dataset.

select max(Transaction_Amount) as Maximum_Transaction
from jpmorgan

--Retrieve all transactions where Transaction_Status is "Completed".

select *
from jpmorgan
where Transaction_Status = 'completed'

--Select all transactions made by the merchant "Walker PLC".

select *
from jpmorgan
where Merchant_Name = 'Walker PLC'

--Count how many transactions have the Compliance_Flag as "None".

select count(Compliance_Flag) as Total_Compliance_flag
from jpmorgan
where Compliance_Flag = 'none'

--Find the minimum Transaction_Amount in EUR currency.

select min(Transaction_Amount) as MIinimum_Transaction
from jpmorgan
where Currency = 'EUR'

--List transactions where Order_Classification is "High Value".

select *
from jpmorgan
where Order_Classification = 'High Value'

--Select transactions with Transaction_Type as "Direct Deposit".

select *
from jpmorgan
where Transaction_Type = 'Direct Deposit'

--Display transactions where Timestamp is "06:19".

select *
from jpmorgan
where Timestamp = '06:19'

--Count the number of transactions per Account_Type.

select Account_Type, count(Account_type) as total_transactions
from jpmorgan
group by Account_Type

--Retrieve the top 5 highest transactions.

select top 5 Transaction_Amount
from jpmorgan
order by Transaction_Amount desc

--Find the total Transaction_Amount per Currency.

select Currency, sum(Transaction_Amount) as total_transaction_amount
from jpmorgan
group by Currency

--Count how many transactions happened in each Bank_Branch.

select Bank_Branch, Count(Transaction_ID) as total_transaction
from jpmorgan
group by Bank_Branch

--Find the average Transaction_Amount for each Transaction_Type.

select Transaction_Type, avg(Transaction_Amount) as avg_transaction_amount
from jpmorgan
group by Transaction_Type

--Select transactions that have a Transaction_Amount between 1000 and 5000.

select *
from jpmorgan
where Transaction_Amount between 1000 and 5000

--Retrieve transactions where Merchant_Name starts with "M".

select *
from jpmorgan
where Merchant_Name like 'm%'

--Display the first 10 transactions sorted by Transaction_ID.

select top 10 *
from jpmorgan
order by Transaction_ID

--Count the number of transactions that are not in USD.

select Count(Transaction_ID) as total_transaction
from jpmorgan
where Currency <> 'USD'

--Find transactions where Merchant_Name contains "LLC".

select *
from jpmorgan
where Merchant_Name like '%LLC%'

--Retrieve transactions made in Seattle, WA and San Francisco, CA.

select *
from jpmorgan
where Bank_Branch in ('Seattle, WA' , 'San Francisco, CA')

--Find transactions where Transaction_Amount is more than twice the average amount.


select avg(Transaction_Amount) as average_Amount
from jpmorgan

select *
from jpmorgan 
where Transaction_Amount > 2 * (select avg(Transaction_Amount) as average_Amount
								from jpmorgan)

--Get the sum of all Transaction_Amount values for "Checking" accounts.

select  Sum(Transaction_amount) as Total_transaction_amount
from jpmorgan
where Account_Type = 'Checking'

--Retrieve transactions where Transaction_Type contains "Deposit" or "Withdrawal".

select *
from jpmorgan
where Transaction_Type like '%Withdrawal%'										
or Transaction_Type like '%Deposit%'

--Count the distinct Merchant_Name values.

select count(distinct(Merchant_Name)) as unique_merchant
from jpmorgan

--Find the total Transaction_Amount per Bank_Branch, sorted in descending order.

select Bank_Branch ,sum(Transaction_Amount) as total_Transaction
from jpmorgan
group by Bank_Branch
order by total_Transaction desc

--Retrieve transactions where Transaction_Amount is in the top 10% of all transactions.

select *
from jpmorgan
where Transaction_Amount >= (
								select Max(Transaction_Amount) * 0.90 
								from jpmorgan
							)

--Find the merchant with the highest total transaction value.

select top 1 Merchant_Name, Sum(Transaction_Amount) as total_transaction_value
from jpmorgan
Group By Merchant_Name

--Get the average Transaction_Amount for each combination of Account_Type and Currency.

select Account_Type, Currency, Avg(Transaction_Amount) as Avg_Transaction_Amount
from jpmorgan
group by Account_Type, Currency

--Find the top 3 Bank_Branch locations with the highest number of transactions.

select top 3 Bank_Branch, count(Transaction_ID) as total_Transaction
from jpmorgan
Group by Bank_Branch

--Retrieve transactions where the Transaction_Amount is greater than the overall average.

select avg(Transaction_Amount) as avg_Transaction_Amount
from jpmorgan

select *
from jpmorgan
where Transaction_Amount > (select avg(Transaction_Amount) as avg_Transaction_Amount
							from jpmorgan )

--Find the Merchant_Name that processed the largest number of transactions.

Select  top 1 Merchant_Name, count(Transaction_ID) as Total_Transaction
from jpmorgan
group by Merchant_Name
order by Total_Transaction desc

--Identify transactions where the Transaction_Amount is exactly the same as another transaction.

select *
from jpmorgan
where Transaction_Amount = Transaction_Amount

--Identify transactions where the Transaction_Amount is exactly the same as another transaction.

select a.*
from jpmorgan a
join jpmorgan b
on a.Transaction_Amount=b.Transaction_Amount
where a.Transaction_ID<>b.Transaction_ID

--Find transactions that occurred in cities where the average transaction is greater than 5000.

select *
from jpmorgan
where (select Bank_Branch, avg(Transaction_Amount) as average_Transaction
		from jpmorgan) > 5000

select *
from jpmorgan
where Bank_Branch in(
					  select Bank_Branch
					  from jpmorgan
					  group by Bank_Branch
					  having avg(Transaction_Amount) > 5000
					  )

--Retrieve the transaction with the second-highest Transaction_Amount.

select *
from (
	  select *, Dense_RANK() over(order by Transaction_amount desc) as rnk
	  from jpmorgan
	  ) r
	  where rnk = 2

--Rank all transactions by Transaction_Amount within each Currency.

select *
from (
	  select *, Dense_RANK() over(partition by Currency order by Transaction_amount desc) as rnk_Within_currency
	  from jpmorgan
	  ) r

--Find merchants with more than 5 transactions in the dataset.

select Merchant_Name, count(Transaction_ID) as total_Transaction
from jpmorgan
group by Merchant_Name
having count(Transaction_ID)  > 5

--Retrieve all transactions where the Transaction_Amount is an odd number.

select *
from jpmorgan
where cast(Transaction_Amount as int) % 2 <> 0

--Calculate the cumulative sum of Transaction_Amount ordered by Transaction_ID.

select Transaction_ID, Transaction_Amount,
sum(Transaction_Amount) over(order by Transaction_ID) as cumulative_sum
from jpmorgan

--Find the difference between each transaction's amount and the previous transaction's amount.

select Transaction_ID, Transaction_Amount,
lag(Transaction_amount) over(order by Transaction_ID) as previous_Transaction,
Transaction_Amount - lag(Transaction_amount) over(order by Transaction_ID) as difference_in_Transaction
from jpmorgan

