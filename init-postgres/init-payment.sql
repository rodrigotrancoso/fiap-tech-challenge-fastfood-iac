-- Create ENUM type for payment status
CREATE TYPE payment_status AS ENUM('PENDING', 'APPROVED', 'FAILED');

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    status payment_status NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);