# Practical 3

# Name: Sinenhlanhla Dlamini

# Student Number: u19028386

# Data and Packages

library(readr)
library(sqldf)
library(lubridate)
library(RH2)

orion_customer <- read_csv("orion_customer.csv")
orion_employee_addresses <- read_csv("orion_employee_addresses.csv")
orion_employee_payroll <- read_csv("orion_employee_payroll.csv")
orion_order_fact <- read_csv("orion_order_fact.csv")
orion_organisation <- read_csv("orion_organisation.csv")
orion_product_dim <- read_csv("orion_product_dim.csv")

# SQL Joins

# Question 1: 
Q1 <- sqldf("SELECT a.Employee_ID, a.Employee_Name,
             b.Job_Title,b.Department
            FROM orion_employee_addresses AS a
            INNER JOIN orion_organisation AS b
            ON a.Employee_ID = b.Employee_ID
            GROUP BY b.Employee_ID
            ORDER BY b.Department
            ")


# Question 2:
Q2 <- sqldf("SELECT c.Manager_ID, d.Employee_Name,
            COUNT(*) AS Amount
            FROM orion_employee_addresses as d
            INNER JOIN orion_organisation AS c
            ON c.Manager_ID = d.Employee_ID
            GROUP BY c.Manager_ID
            ORDER BY Amount DESC
           ")

# Question 3:
Q3 <- sqldf("SELECT e.Product_Name,e.Product_ID,f.Quantity_Ordered
            FROM orion_product_dim AS e
            LEFT JOIN orion_order_fact AS f
            ON e.Product_ID = f.Product_ID
            WHERE f.Order_ID IS NULL")


# Question 4:
Q4 <- sqldf("SELECT g.Customer_ID, g.Customer_Name, 
            COUNT (*) AS Total_Purchase
            FROM orion_customer AS g
            INNER JOIN orion_order_fact AS i
            ON g.Customer_ID = i.Customer_ID
            INNER JOIN orion_product_dim AS h
            ON h.Product_ID = i.Product_ID
            WHERE i.Employee_ID = '99999999' 
            AND g.Customer_Country IN ('US','AU')
            AND  h.Supplier_Country IS g.Customer_Country
            GROUP BY g.Customer_ID,g.Customer_Name
            ")



# SQL Subqueries

# Question 5 :
Q5_a <- sqldf("SELECT Employee_ID
              FROM orion_employee_payroll
              WHERE month(Employee_Hire_Date) = 03
              ")

Q5_b <- sqldf("SELECT Employee_ID, Employee_Name
             FROM orion_employee_addresses
             WHERE Employee_ID in
             (SELECT Employee_ID
             FROM orion_employee_payroll
             WHERE month(Employee_Hire_Date)=03)
             ")


# Question 6:
Q6_a <- sqldf("SELECT k.Department, SUM(j.Salary) AS Dept_Salary_total
              FROM orion_organisation AS k
              INNER JOIN orion_employee_payroll AS j 
              on k.Employee_ID = j.Employee_ID
              GROUP BY k.Department
              ") 

Q6_b <- sqldf("SELECT l.Employee_ID, l.Employee_Name, m.Department
              FROM orion_organisation AS m
              INNER JOIN orion_employee_addresses AS l 
              on l.Employee_ID = m.Employee_ID
              ")

Q6_c <- sqldf("SELECT u.Department, Employee_Name, Salary, 
              Salary/Dept_Salary_total AS Percent
              FROM orion_employee_payroll AS pay 
              INNER JOIN 
              (SELECT v.Employee_ID, v.Employee_Name, t.Department
              FROM orion_employee_addresses AS v 
              INNER JOIN orion_organisation AS t
              WHERE v.Employee_ID = t.Employee_ID)
              AS u 
              ON pay.Employee_ID = u.Employee_ID 
              INNER JOIN
              (SELECT k.Department, 
              SUM(j.Salary) AS Dept_Salary_total
              FROM orion_organisation AS k
              INNER JOIN orion_employee_payroll AS j 
              ON k.Employee_ID = j.Employee_ID
              GROUP BY k.Department) AS s
              ON s.Department = u.Department
              ORDER BY Department, Percent DESC
              ")

