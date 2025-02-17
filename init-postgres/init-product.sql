-- Create ENUM type for product categories
CREATE TYPE product_category AS ENUM ('Food', 'Beverage', 'Snack', 'Dessert');

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    category product_category NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);