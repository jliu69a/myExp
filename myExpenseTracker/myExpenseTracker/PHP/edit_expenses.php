<?php
// http://www.mysohoplace.com/php_hdb/php_GL/prod/edit_expenses.php

// Create connection
include('connection_header.php');

if ($_POST) {
  $id = mysqli_real_escape_string($con, $_POST['id']);
  $expDate = mysqli_real_escape_string($con, $_POST['date']);
  $expTime = mysqli_real_escape_string($con, $_POST['time']);
  $vendorId = mysqli_real_escape_string($con, $_POST['vendorid']);
  $paymentId = mysqli_real_escape_string($con, $_POST['paymentid']);
  $amount = mysqli_real_escape_string($con, $_POST['amount']);
  $note = mysqli_real_escape_string($con, $_POST['note']);
  $isEdit = mysqli_real_escape_string($con, $_POST['isedit']);
  $current = mysqli_real_escape_string($con, $_POST['current']);
  
  $insertSql = "INSERT INTO `MyExp_Data`(`date`, `time`, `vendor_id`, `payment_id`, `amount`, `note`) VALUES ('$expDate', '$expTime', $vendorId, $paymentId, '$amount', '$note');";

  $updateSql = "UPDATE `MyExp_Data` SET `date`='$expDate', `time`='$expTime', `vendor_id`=$vendorId, `payment_id`=$paymentId, `amount`='$amount', `note`='$note' WHERE `id`=$id";

  $deleteSql = "DELETE FROM `MyExp_Data` WHERE `id` = $id;";
  
  if ($id == '-1') {
    $result2 = mysqli_query($con, $insertSql);
  }
  else {
    if ($isEdit == '0') {
      $result3 = mysqli_query($con, $deleteSql);
    }
    else {
      $result4 = mysqli_query($con, $updateSql);
    }
  }
  
  $selectSql = "SELECT a.id, a.date, a.time, a.vendor_id, b.vendor, a.payment_id, c.payment, a.amount, a.note FROM MyExp_Data a, MyExp_Venders b, MyExp_Payments c WHERE a.vendor_id = b.id AND a.payment_id = c.id AND a.date = '$current' ORDER BY a.time DESC;";
  
  if ($result = mysqli_query($con, $selectSql)) {
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
  echo "not POST method";
}

mysqli_close($con);
?>
