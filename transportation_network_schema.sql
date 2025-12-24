-- ============================================================================
-- TRANSPORTATION NETWORK DATABASE SCHEMA
-- DataCo Supply Chain Analysis for Amazon Transportation Optimization
-- Author: Samiya Islam
-- Date: December 2024
-- ============================================================================

-- ============================================================================
-- DATABASE CREATION
-- ============================================================================

DROP DATABASE IF EXISTS transportation_network;
CREATE DATABASE transportation_network;
USE transportation_network;

-- ============================================================================
-- TABLE CREATION - NORMALIZED SCHEMA
-- ============================================================================

-- Orders Table (Main fact table)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    customer_id INT,
    product_id INT,
    shipping_id INT,
    warehouse_id INT,
    order_quantity INT,
    product_price DECIMAL(10, 2),
    sales_amount DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    order_status VARCHAR(50),
    INDEX idx_customer (customer_id),
    INDEX idx_product (product_id),
    INDEX idx_shipping (shipping_id),
    INDEX idx_warehouse (warehouse_id),
    INDEX idx_order_date (order_date)
);

-- Shipping Table (Delivery performance data)
CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipping_mode VARCHAR(50),
    scheduled_days INT,
    actual_days INT,
    delivery_variance_days INT,
    late_delivery_risk TINYINT(1),
    delivery_status VARCHAR(50),
    shipping_cost DECIMAL(10, 2),
    INDEX idx_order (order_id),
    INDEX idx_mode (shipping_mode),
    INDEX idx_late_risk (late_delivery_risk),
    INDEX idx_status (delivery_status)
);

-- Customers Table (Customer information)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(200),
    customer_segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50),
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    INDEX idx_state (state),
    INDEX idx_region (region),
    INDEX idx_city (city)
);

-- Products Table (Product catalog)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200),
    category_id INT,
    department VARCHAR(100),
    product_description TEXT,
    INDEX idx_category (category_id)
);

-- Categories Table (Product categories)
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100),
    category_type VARCHAR(50)
);

-- Warehouse Table (Distribution centers)
CREATE TABLE warehouse (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100),
    warehouse_location VARCHAR(100),
    warehouse_state VARCHAR(50),
    warehouse_region VARCHAR(50),
    INDEX idx_location (warehouse_location),
    INDEX idx_state (warehouse_state)
);

-- ============================================================================
-- SAMPLE DATA INSERTION (Template)
-- ============================================================================

-- Note: In production, this would be populated from the CSV using LOAD DATA INFILE
-- or through an ETL process

-- Sample warehouse data
INSERT INTO warehouse (warehouse_name, warehouse_location, warehouse_state, warehouse_region) VALUES
('Northeast Hub', 'Boston', 'MA', 'Northeast'),
('Southeast Hub', 'Atlanta', 'GA', 'Southeast'),
('Midwest Hub', 'Chicago', 'IL', 'Midwest'),
('West Hub', 'Los Angeles', 'CA', 'West'),
('Southwest Hub', 'Dallas', 'TX', 'Southwest');

-- Sample categories
INSERT INTO categories (category_name, category_type) VALUES
('Cleats', 'Sporting Goods'),
('Men''s Footwear', 'Sporting Goods'),
('Women''s Apparel', 'Clothing'),
('Cardio Equipment', 'Sporting Goods'),
('Camping & Hiking', 'Sporting Goods');

-- ============================================================================
-- KEY ANALYTICAL QUERIES
-- ============================================================================

-- Query 1: Overall Late Delivery Rate by Shipping Mode
SELECT 
    shipping_mode,
    COUNT(*) as total_shipments,
    SUM(late_delivery_risk) as late_deliveries,
    ROUND(AVG(late_delivery_risk) * 100, 2) as late_delivery_rate_pct,
    AVG(actual_days) as avg_actual_days,
    AVG(scheduled_days) as avg_scheduled_days,
    AVG(delivery_variance_days) as avg_delay_days,
    ROUND(AVG(shipping_cost), 2) as avg_shipping_cost
FROM shipping
GROUP BY shipping_mode
ORDER BY late_delivery_rate_pct DESC;

-- Query 2: Geographic Performance Analysis (State-Level)
SELECT 
    c.state,
    c.region,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_delivery_rate_pct,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days,
    ROUND(SUM(o.sales_amount), 2) as total_sales,
    ROUND(AVG(o.sales_amount), 2) as avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY c.state, c.region
HAVING total_orders >= 50  -- Filter for statistical significance
ORDER BY late_delivery_rate_pct DESC
LIMIT 20;

-- Query 3: Product Category Performance Analysis
SELECT 
    cat.category_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_delivery_rate_pct,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days,
    ROUND(SUM(o.sales_amount), 2) as total_sales,
    ROUND(SUM(o.profit), 2) as total_profit,
    ROUND(AVG(o.profit / o.sales_amount) * 100, 2) as profit_margin_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY cat.category_name
HAVING total_orders >= 100
ORDER BY late_delivery_rate_pct DESC;

-- Query 4: Warehouse Performance Comparison
SELECT 
    w.warehouse_name,
    w.warehouse_location,
    w.warehouse_state,
    COUNT(DISTINCT o.order_id) as orders_fulfilled,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_delivery_rate_pct,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days,
    ROUND(AVG(s.shipping_cost), 2) as avg_shipping_cost,
    ROUND(SUM(o.sales_amount), 2) as total_sales
FROM orders o
JOIN warehouse w ON o.warehouse_id = w.warehouse_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY w.warehouse_id, w.warehouse_name, w.warehouse_location, w.warehouse_state
ORDER BY late_delivery_rate_pct ASC;

-- Query 5: Shipping Mode + Route Combination Analysis (Bottleneck Identification)
SELECT 
    s.shipping_mode,
    c.state as destination_state,
    w.warehouse_state as origin_state,
    COUNT(*) as shipment_count,
    SUM(s.late_delivery_risk) as late_count,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(AVG(s.delivery_variance_days), 2) as avg_delay_days,
    ROUND(AVG(s.shipping_cost), 2) as avg_cost
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN warehouse w ON o.warehouse_id = w.warehouse_id
GROUP BY s.shipping_mode, c.state, w.warehouse_state
HAVING shipment_count >= 50
ORDER BY late_rate_pct DESC, avg_delay_days DESC
LIMIT 30;

-- Query 6: Time-Based Performance Trends
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') as order_month,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days,
    ROUND(SUM(o.sales_amount), 2) as total_sales
FROM orders o
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY order_month
ORDER BY order_month;

-- Query 7: Customer Segment Analysis
SELECT 
    c.customer_segment,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(AVG(o.sales_amount), 2) as avg_order_value,
    ROUND(SUM(o.sales_amount), 2) as total_sales,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY c.customer_segment
ORDER BY total_sales DESC;

-- Query 8: High-Value Customer Late Delivery Impact
SELECT 
    c.customer_segment,
    c.state,
    COUNT(DISTINCT o.customer_id) as customer_count,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(SUM(o.sales_amount), 2) as total_sales,
    ROUND(SUM(CASE WHEN s.late_delivery_risk = 1 THEN o.sales_amount ELSE 0 END), 2) as revenue_at_risk
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY c.customer_segment, c.state
HAVING total_orders >= 20
ORDER BY revenue_at_risk DESC
LIMIT 25;

-- Query 9: Cost Efficiency Analysis by Shipping Mode
SELECT 
    s.shipping_mode,
    COUNT(*) as total_shipments,
    ROUND(AVG(s.shipping_cost), 2) as avg_cost,
    ROUND(AVG(s.actual_days), 2) as avg_days,
    ROUND(AVG(s.shipping_cost / s.actual_days), 2) as cost_per_day,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(AVG(o.sales_amount / s.shipping_cost), 2) as revenue_to_cost_ratio
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
GROUP BY s.shipping_mode
ORDER BY cost_per_day ASC;

-- Query 10: Route Optimization - Best vs Worst Performing Routes
WITH route_performance AS (
    SELECT 
        w.warehouse_state as origin,
        c.state as destination,
        COUNT(*) as shipment_count,
        ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
        ROUND(AVG(s.actual_days), 2) as avg_days,
        ROUND(AVG(s.shipping_cost), 2) as avg_cost
    FROM shipping s
    JOIN orders o ON s.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN warehouse w ON o.warehouse_id = w.warehouse_id
    GROUP BY origin, destination
    HAVING shipment_count >= 30
)
SELECT 
    'Best Performing' as category,
    origin,
    destination,
    shipment_count,
    late_rate_pct,
    avg_days,
    avg_cost
FROM route_performance
ORDER BY late_rate_pct ASC, avg_days ASC
LIMIT 10

UNION ALL

SELECT 
    'Worst Performing' as category,
    origin,
    destination,
    shipment_count,
    late_rate_pct,
    avg_days,
    avg_cost
FROM route_performance
ORDER BY late_rate_pct DESC, avg_days DESC
LIMIT 10;

-- ============================================================================
-- ADVANCED ANALYTICS QUERIES
-- ============================================================================

-- Query 11: Month-over-Month Performance Change
WITH monthly_metrics AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') as month,
        ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate,
        ROUND(AVG(s.actual_days), 2) as avg_days,
        COUNT(*) as order_count
    FROM orders o
    JOIN shipping s ON o.shipping_id = s.shipping_id
    GROUP BY month
)
SELECT 
    month,
    late_rate,
    LAG(late_rate) OVER (ORDER BY month) as prev_month_late_rate,
    late_rate - LAG(late_rate) OVER (ORDER BY month) as late_rate_change,
    avg_days,
    order_count
FROM monthly_metrics
ORDER BY month;

-- Query 12: Pareto Analysis - 80/20 Rule for Late Deliveries
WITH state_late_deliveries AS (
    SELECT 
        c.state,
        SUM(s.late_delivery_risk) as late_count,
        COUNT(*) as total_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN shipping s ON o.shipping_id = s.shipping_id
    GROUP BY c.state
),
cumulative_late AS (
    SELECT 
        state,
        late_count,
        total_count,
        ROUND(late_count * 100.0 / SUM(late_count) OVER (), 2) as pct_of_late,
        ROUND(SUM(late_count) OVER (ORDER BY late_count DESC) * 100.0 / 
              SUM(late_count) OVER (), 2) as cumulative_pct
    FROM state_late_deliveries
)
SELECT 
    state,
    late_count,
    total_count,
    pct_of_late,
    cumulative_pct,
    CASE WHEN cumulative_pct <= 80 THEN 'Priority Focus' ELSE 'Secondary' END as priority_tier
FROM cumulative_late
ORDER BY late_count DESC;

-- ============================================================================
-- PERFORMANCE OPTIMIZATION INDEXES
-- ============================================================================

CREATE INDEX idx_orders_date_customer ON orders(order_date, customer_id);
CREATE INDEX idx_shipping_mode_late ON shipping(shipping_mode, late_delivery_risk);
CREATE INDEX idx_customers_state_segment ON customers(state, customer_segment);
CREATE INDEX idx_products_category ON products(category_id);

-- ============================================================================
-- VIEWS FOR DASHBOARD/REPORTING
-- ============================================================================

-- View 1: Real-time KPI Dashboard
CREATE OR REPLACE VIEW v_kpi_dashboard AS
SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as total_late_deliveries,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as overall_late_rate_pct,
    ROUND(AVG(s.actual_days), 2) as avg_delivery_days,
    ROUND(AVG(s.delivery_variance_days), 2) as avg_delay_days,
    ROUND(SUM(o.sales_amount), 2) as total_revenue,
    ROUND(SUM(o.profit), 2) as total_profit,
    COUNT(DISTINCT o.customer_id) as unique_customers
FROM orders o
JOIN shipping s ON o.shipping_id = s.shipping_id;

-- View 2: Shipping Mode Performance Summary
CREATE OR REPLACE VIEW v_shipping_mode_performance AS
SELECT 
    shipping_mode,
    COUNT(*) as total_shipments,
    SUM(late_delivery_risk) as late_deliveries,
    ROUND(AVG(late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(AVG(actual_days), 2) as avg_delivery_days,
    ROUND(AVG(shipping_cost), 2) as avg_cost,
    ROUND(AVG(delivery_variance_days), 2) as avg_variance
FROM shipping
GROUP BY shipping_mode;

-- View 3: Geographic Performance Summary
CREATE OR REPLACE VIEW v_geographic_performance AS
SELECT 
    c.state,
    c.region,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(s.late_delivery_risk) as late_orders,
    ROUND(AVG(s.late_delivery_risk) * 100, 2) as late_rate_pct,
    ROUND(SUM(o.sales_amount), 2) as total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY c.state, c.region;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
