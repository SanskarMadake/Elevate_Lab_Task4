
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order_Items Table 
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT ,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Success',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert Users
INSERT INTO users (name, email, phone) VALUES
('Amit Sharma', 'amit.sharma@example.com', '9123456780'),
('Priya Singh', 'priya.singh@example.com', NULL),
('Rohit Kumar', 'rohit.kumar@example.com', '9988776655'),
('Neha Patil', 'neha.patil@example.com', '9112233445'),
('Siddharth Deshmukh', 'siddharth.deshmukh@example.com', NULL);

-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Mobiles & Gadgets'),
('Ethnic Wear'),
('Stationery'),
('Home Appliances'),
('Sports & Fitness');

-- Insert Products 
INSERT INTO products (name, price, stock, category_id) VALUES
('Mobile Phone', 12000.00, 40, 1),     
('Laptop', 50000.00, 15, 1),           
('Kurta', 800.00, 80, 2),              
('Notebook', 250.00, 150, 3),          
('Fitness Band', 2000.00, 30, 5);

-- Insert Orders
INSERT INTO orders (user_id, status) VALUES
(1, 'Shipped'),
(2, 'Pending'),
(3, DEFAULT);

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 12000.00),  
(1, 3, 2, 1600.00),    
(2, 2, 1, 50000.00),  
(3, 4, 5, 1250.00),  
(2, 5, 1, 2000.00);

-- Insert Payments
INSERT INTO payments (order_id, amount, method, status) VALUES
(1, 13600.00, 'Credit Card', 'Success'),
(2, 52000.00, 'UPI', 'Success'),
(3, 1250.00, 'Net Banking', 'Pending'),
(2, 2000.00, 'UPI', 'Success');

-- Count total users
SELECT COUNT(*) AS total_users
FROM users;

-- Number of products in each category
SELECT c.category_name, COUNT(p.product_id) AS total_products
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- Total orders placed by each user
SELECT u.name, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name;

-- Average order value (AOV)
SELECT AVG(amount) AS avg_order_value
FROM payments;

-- Total sales (revenue) by product
SELECT p.name, SUM(oi.quantity * oi.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.name;

-- Total revenue by category
SELECT c.category_name, SUM(oi.quantity * oi.price) AS category_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name;

-- Number of orders by status
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status;

-- Users who placed more than 3 orders
SELECT u.name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name
HAVING COUNT(o.order_id) > 3;

-- Payment methods usage count
SELECT method, COUNT(payment_id) AS total_payments
FROM payments
GROUP BY method;

-- Highest spending user
SELECT u.name, SUM(p.amount) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY u.name
ORDER BY total_spent DESC
LIMIT 1;
