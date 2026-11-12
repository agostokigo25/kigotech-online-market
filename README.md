# KigoTech Online Market — PHP + MySQL starter

## Requirements
- PHP 8.1+ (PHP 8.4 is fine), MySQL/MariaDB, Apache (XAMPP works)
- PHP extensions: pdo_mysql, curl, openssl
- HTTPS for production

## Run locally with XAMPP
1. Extract this folder into `C:\xampp\htdocs\`.
2. Start Apache and MySQL in XAMPP.
3. Open phpMyAdmin at `http://localhost/phpmyadmin`.
4. Import `database.sql` (it creates the `kigotech_market` database and tables).
5. Edit `config/config.php` and set the database username/password.
6. Open `http://localhost/KigoTech_online_market/`.

The demo environment returns the one-time login code in the browser response so you can test without an SMS/email provider. This is ONLY for local testing. Set `APP_ENV` to `production` and connect an SMS/email OTP provider before hosting publicly.

## Admin access
For local testing, open `admin/setup_admin.php` once and follow the instructions shown there to create the first admin. Delete `admin/setup_admin.php` after creating the admin. Then sign in at `/admin/login.php`.

## Safaricom Daraja (production)
Open `config/daraja.php` and enter your Daraja Consumer Key, Consumer Secret, shortcode, passkey, and callback URL. Do not put credentials in JavaScript, HTML, GitHub, or public files. Keep the credentials on the server, use HTTPS, and set `DARAJA_ENV` to `production` only after Safaricom has approved your live shortcode.
The current checkout creates an order and records a pending payment. The STK Push helper is scaffolded, but you must add your approved Safaricom callback URL and test the full callback/payment verification flow in Daraja sandbox before live use. Never mark an order paid based only on the browser response.

## Features included
- Product catalogue with the supplied utensil/cookware prices
- Phone/email OTP login flow (local development code display; production provider hook required)
- Add to cart, favourites, comments, place orders
- Delivery name, phone, county/town, and detailed location/address
- Order tracking/status timeline
- Admin dashboard: members, orders, order status, comments, wallet ledger, pending transactions
- MySQL schema with prepared statements and password hashing for admin

## Important production checklist
- Configure a real SMS/email OTP service.
- Configure Daraja and verify callbacks server-side.
- Use HTTPS, strong database credentials, and a non-public config file where possible.
- Change admin credentials immediately; remove setup_admin.php.
- Add privacy policy/terms and clear delivery/returns information.
- Test stock management, refunds, M-Pesa reconciliation, and backups.
- “Wallet balance” in the admin panel is a ledger summary of recorded payments minus recorded refunds/payouts; it is not a Safaricom account balance and must be reconciled against your actual M-Pesa statement.
