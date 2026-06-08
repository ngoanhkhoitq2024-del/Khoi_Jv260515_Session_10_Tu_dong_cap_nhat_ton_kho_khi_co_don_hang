CREATE TABLE products(
    pro_id SERIAL PRIMARY KEY,
    pro_name VARCHAR(30),
    stock INT  -- Số lượng sp tồn kho
);
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    quantity INT, -- Số lượng sản phẩm khách đặt
    pro_id INT REFERENCES products(pro_id)
);
INSERT INTO products(pro_name, stock)
VALUES ('Nước ép Cam', '6'),
       ('Sinh tố', '3'),
       ('Milo đá xay', '5');
CREATE OR REPLACE FUNCTION change_product_stock()
RETURNS TRIGGER AS $$
    BEGIN
        IF TG_OP = 'INSERT' THEN
            UPDATE products
            SET stock = stock - NEW.quantity
            WHERE pro_id = NEW.pro_id;
            RETURN NEW;
        ELSIF TG_OP = 'UPDATE' THEN
            UPDATE products
            SET stock = stock + OLD.quantity - NEW.quantity
            WHERE pro_id = NEW.pro_id;
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE products
            SET stock = stock + OLD.quantity
            WHERE pro_id = OLD.pro_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_stock
    AFTER INSERT OR UPDATE OR DELETE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION change_product_stock();

SELECT * FROM products;
SELECT * FROM orders;

INSERT INTO orders(pro_id, quantity)
VALUES ('2', '5');
    
UPDATE orders
SET quantity = 3
WHERE pro_id = 2;

DELETE FROM orders
WHERE pro_id = 2;



