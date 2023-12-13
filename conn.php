<?php

$connect = new mysqli("localhost", "root", "", "ade_mestakung_db");

if ($connect) {
   
} else {
    echo "Connection Failed";
    exit();
}
