<?php
// http://www.mysohoplace.com/php_hdb/php_GL/prod/reports.php

// Create connection
include('connection_header.php');

if ($_GET) {
  $monthYear1 = mysqli_real_escape_string($con, $_GET['monthyear1']);
  $monthYear2 = mysqli_real_escape_string($con, $_GET['monthyear2']);
  
  $sql1 = "select b.vendor as vendor, sum(a.amount) as totalAmount from MyExp_Data a, MyExp_Venders b where a.vendor_id = b.id and (a.date like '$monthYear1%' or a.date like '$monthYear2%') group by a.vendor_id order by b.vendor asc;";
  
  $sql2 = "select b.payment as payment, sum(a.amount) as totalAmount from MyExp_Data a, MyExp_Payments b where a.payment_id = b.id and (a.date like '$monthYear1%' or a.date like '$monthYear2%') group by a.payment_id order by b.payment asc;";
  
  $resultArray1 = array();
  $resultArray2 = array();
  
  if ($result = mysqli_query($con, $sql1)) {
    $tempArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray1, $tempArray);
    }
  }
  
  if ($result = mysqli_query($con, $sql2)) {
    $tempArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray2, $tempArray);
    }
  }
  
  header('Content-Type: application/json');
  $data = array('paymentTotal' => $resultArray2, 'vendorTotal' => $resultArray1);
  echo json_encode($data);
}
else {
  echo "not GET method";
}

mysqli_close($con);
?>
