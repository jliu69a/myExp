<?php
// http://www.mysohoplace.com/php_hdb/php_GL/prod/expenses.php

// Create connection
include('connection_header.php');

if ($_GET) {
  $date = mysqli_real_escape_string($con, $_GET['date']);
  
  $sql = "SELECT a.id, a.date, a.time, a.vendor_id, b.vendor, a.payment_id, c.payment, a.amount, a.note FROM MyExp_Data_Home a, MyExp_Venders b, MyExp_Payments c WHERE a.vendor_id = b.id AND a.payment_id = c.id AND a.date = '$date' ORDER BY a.time DESC;";
  
  if ($result = mysqli_query($con, $sql)) {
    $tempArray = array();
    $resultArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray, $tempArray);
    }
  }

  header('Content-Type: application/json');
  $data = array('data' => $resultArray);
  echo json_encode($data);
}
else {
  echo "not GET method";
}

mysqli_close($con);
?>
