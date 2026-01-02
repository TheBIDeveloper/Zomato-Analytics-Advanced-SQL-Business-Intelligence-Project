USE ZomatoAnalytics;
GO

-- Customers
INSERT INTO customers VALUES
(1, 'Amit', 'Mumbai', '2023-01-10'),
(2, 'Neha', 'Pune', '2023-02-15'),
(3, 'Rahul', 'Bangalore', '2023-03-05'),
(4, 'Priya', 'Mumbai', '2023-03-18'),
(5, 'Suresh', 'Delhi', '2023-04-01');

-- Restaurants
INSERT INTO restaurants VALUES
(101, 'Spice Hub', 'Mumbai', 4.5),
(102, 'Food Factory', 'Pune', 4.2),
(103, 'Taste of South', 'Bangalore', 4.6),
(104, 'Urban Tadka', 'Delhi', 4.1);

-- Orders
INSERT INTO orders VALUES
(1001, 1, 101, '2023-06-01 13:20:00', 450.00),
(1002, 2, 102, '2023-06-03 20:10:00', 320.00),
(1003, 1, 101, '2023-06-10 19:00:00', 520.00),
(1004, 3, 103, '2023-07-05 14:30:00', 610.00),
(1005, 4, 101, '2023-07-12 21:15:00', 390.00),
(1006, 5, 104, '2023-08-01 13:45:00', 480.00);

-- Order Items
INSERT INTO order_items VALUES
(1, 1001, 'Paneer Butter Masala', 1, 250),
(2, 1001, 'Butter Naan', 2, 100),
(3, 1002, 'Veg Burger', 2, 160),
(4, 1003, 'Paneer Tikka', 1, 300),
(5, 1004, 'Masala Dosa', 2, 200),
(6, 1005, 'Dal Tadka', 1, 220),
(7, 1006, 'Chole Bhature', 2, 240);
