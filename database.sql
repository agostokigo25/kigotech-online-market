CREATE DATABASE IF NOT EXISTS kigotech_market CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kigotech_market;

CREATE TABLE IF NOT EXISTS users (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(120) NULL,
 phone VARCHAR(25) NULL UNIQUE,
 email VARCHAR(190) NULL UNIQUE,
 county VARCHAR(100) NULL,
 town VARCHAR(100) NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CHECK (phone IS NOT NULL OR email IS NOT NULL)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS otp_codes (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 identifier VARCHAR(190) NOT NULL,
 code_hash VARCHAR(255) NOT NULL,
 expires_at DATETIME NOT NULL,
 used_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX(identifier)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admins (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 email VARCHAR(190) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(180) NOT NULL,
 description TEXT NULL,
 category VARCHAR(100) NOT NULL,
 price DECIMAL(10,2) NOT NULL,
 image_url VARCHAR(500) NULL,
 stock INT NOT NULL DEFAULT 0,
 active TINYINT(1) NOT NULL DEFAULT 1,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS favorites (
 user_id BIGINT UNSIGNED NOT NULL,
 product_id BIGINT UNSIGNED NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY(user_id, product_id),
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS comments (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NOT NULL,
 product_id BIGINT UNSIGNED NOT NULL,
 comment TEXT NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NOT NULL,
 order_number VARCHAR(40) NOT NULL UNIQUE,
 customer_name VARCHAR(120) NOT NULL,
 phone VARCHAR(25) NOT NULL,
 county VARCHAR(100) NOT NULL,
 town VARCHAR(100) NOT NULL,
 delivery_location TEXT NOT NULL,
 total DECIMAL(10,2) NOT NULL,
 status ENUM('Pending','Confirmed','Processing','Dispatched','Delivered','Cancelled') DEFAULT 'Pending',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 order_id BIGINT UNSIGNED NOT NULL,
 product_id BIGINT UNSIGNED NULL,
 product_name VARCHAR(180) NOT NULL,
 unit_price DECIMAL(10,2) NOT NULL,
 quantity INT NOT NULL,
 FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,
 FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transactions (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NULL,
 order_id BIGINT UNSIGNED NULL,
 type ENUM('payment','refund','adjustment') NOT NULL,
 amount DECIMAL(10,2) NOT NULL,
 status ENUM('pending','completed','failed') DEFAULT 'pending',
 method VARCHAR(40) DEFAULT 'M-Pesa',
 mpesa_receipt VARCHAR(80) NULL,
 checkout_request_id VARCHAR(100) NULL,
 note VARCHAR(255) NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
 FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE SET NULL,
 INDEX(status), INDEX(checkout_request_id)
) ENGINE=InnoDB;

INSERT INTO products(name,description,category,price,stock) VALUES
('Cooking Stick / Wooden Spoon (Small)','Small wooden cooking spoon.','Individual Utensils',185,25),
('Cheese Grater','Kitchen cheese grater.','Individual Utensils',640,15),
('Sink Strainer','Sink strainer.','Individual Utensils',123,30),
('Lemon Squeezer','Choose your preferred option; displayed starting price.','Individual Utensils',125,20),
('Utility Knife','Tramontina Plenus utility knife.','Individual Utensils',360,15),
('Slotted Turner (Stainless Steel)','Stainless steel slotted turner.','Individual Utensils',1495,10),
('Bamboo Cutting Board (20x30cm)','Bamboo cutting board.','Individual Utensils',800,12),
('Ramen/Soup Spoon Set (2 pcs, Bamboo)','Two-piece bamboo spoon set.','Individual Utensils',1850,10),
('19-Piece Cutlery & Silicone Spoon Set','Wooden handles and caddy.','Utensil & Cutlery Sets',2999,10),
('6-Piece Wooden Cooking Set','Six-piece wooden cooking set.','Utensil & Cutlery Sets',3800,8),
('Full Silicone Cooking Sets','Heat-resistant silicone cooking set.','Utensil & Cutlery Sets',3500,10),
('Tornado Original Sufuria Set (14 pcs)','Fourteen-piece sufuria set.','Cookware, Pots & Hotpots',6000,5),
('Happy Home Hotpot Set (4 pcs)','Four-piece hotpot set.','Cookware, Pots & Hotpots',2999,8),
('Redberry Hot Pots (4 pcs)','Four-piece hotpot set.','Cookware, Pots & Hotpots',4300,6),
('Milton Hotpots (4 pcs)','Four-piece hotpot set.','Cookware, Pots & Hotpots',4500,6),
('Heavy Duty Cooking Pots (7 pcs)','Seven-piece heavy duty cooking pot set.','Cookware, Pots & Hotpots',5500,5),
('Non-Stick Cookware Set (14-Piece TC)','Fourteen-piece non-stick cookware set.','Cookware, Pots & Hotpots',5800,5),
('Thermos Flask (2L)','Two-litre flask.','Cookware, Pots & Hotpots',2000,10),
('Thermos Flask (3.5L)','Three-and-a-half-litre flask.','Cookware, Pots & Hotpots',3500,8);
