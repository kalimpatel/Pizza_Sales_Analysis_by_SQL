select * from pizza_types --pizzatypeid,name,cateogery,ingredient
select * from order_details --orderdetailid,orderid,pizzaid,quantity
select * from pizzas --pizzaid,pizzatypeid,size,price
select * from orders --orderid,date,time

--1) retrive no of order placed

select  COUNT(order_id)as 'Total Order'from orders 

--2) Calculate the total revenue generated from pizza sales.

select cast(sum(price * quantity)as decimal(10,0)) as'Total Revenue' from pizzas a
join order_details b
on a.pizza_id=b.pizza_id


--3) Identify the highest-priced pizza.

select top 1 name, cast(price as decimal(10,0)) as 'Highest Price Pizza' from pizza_types a 
join pizzas b
on a.pizza_type_id =b.pizza_type_id
order by price desc


      --OR

with cte as (
select pizza_types.name as 'Pizza_Name', cast(pizzas.price as decimal(10,2)) as 'Price',
rank() over (order by price desc) as rnk
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id)

select Pizza_Name,Price from cte where rnk = 1 

--4) Identify the most common pizza size ordered.

select size,count(distinct order_id) as 'No of Orders',sum(quantity) as 'Total_Quantity_Ordered' from pizzas a
join order_details b
on a.pizza_id = b.pizza_id
group by size 
order by Total_Quantity_ordered desc


--5) List the top 5 most ordered pizza types along with their quantities.

select top 5 name as 'pizza_name',sum(quantity) as 'Total_Ordered' from pizza_types a
join pizzas b on a.pizza_type_id = b.pizza_type_id 
join order_details c on b.pizza_id=c.pizza_id 
group by name
order by Total_Ordered desc




--6) find the total quantity of each pizza category ordered.


select top 5 category, sum(quantity) as 'Total Quantity Ordered'
from order_details a
join pizzas b on b.pizza_id = a.pizza_id
join pizza_types c on c.pizza_type_id = b.pizza_type_id
group by c.category 
order by sum(quantity)  desc


--7)  Determine the distribution of orders by hour of the day.



select datepart(hour, time) as 'Hour of the day', count( order_id) as 'No of Orders'from orders
group by datepart(hour, time) 
order by 'No of Orders' desc


-- 8) Calculate the average number of pizzas ordered per day.

select avg(Total_pizza_order)as [Avg Number of pizzas ordered per day] from
(select date,sum(quantity) as 'Total_pizza_order' from orders a 
join order_details b on a.order_id = b.order_id
group by date ) as pizza_ordered 


               -- OR


with cte as(
select orders.date as 'Date', sum(order_details.quantity) as 'Total Pizza Ordered that day'
from order_details
join orders on order_details.order_id = orders.order_id
group by orders.date
)
select avg([Total Pizza Ordered that day]) as [Avg Number of pizzas ordered per day]  from cte


--9) Determine the top 3 most ordered pizza types based on revenue.


select top 3 name, sum(quantity*price) as 'Revenue from pizza'
from order_details a 
join pizzas b on a.pizza_id =b.pizza_id
join pizza_types c on c.pizza_type_id =b. pizza_type_id
group by name
order by [Revenue from pizza] desc






