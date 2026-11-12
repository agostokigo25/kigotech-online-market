<?php
// Safaricom sends the STK Push result here. Validate the payload and match CheckoutRequestID
// to a pending transaction. Only then mark the transaction completed and order confirmed.
// Do not trust a client/browser redirect as proof of payment.
require __DIR__.'/../config/config.php';
$payload=json_decode(file_get_contents('php://input'),true);
file_put_contents(__DIR__.'/../storage_daraja_callbacks.log',date('c')." ".json_encode($payload).PHP_EOL,FILE_APPEND);
http_response_code(200);header('Content-Type: application/json');echo json_encode(['ResultCode'=>0,'ResultDesc'=>'Callback received']);
