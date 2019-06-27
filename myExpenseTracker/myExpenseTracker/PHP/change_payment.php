<?php
//http://www.mysohoplace.com/php_hdb/php_GL/prod/change_payment.php

// Create connection
include('connection_header.php');

if ($_POST) {
  $id = mysqli_real_escape_string($con, $_POST['id']);
  $name = mysqli_real_escape_string($con, $_POST['name']);
  $isEdit = mysqli_real_escape_string($con, $_POST['edit']);
  
  $name = str_replace("&amp;", "&", $name);
  
  $insertSql = "INSERT INTO `MyExp_Payments` (`payment`) VALUES ('$name');";
  $updateSql = "UPDATE `MyExp_Payments` SET `payment`='$name' WHERE `id`=$id;";
  $deleteSql = "DELETE FROM `MyExp_Payments` WHERE `id`=$id;";
  
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
  
  $selectSql = "SELECT `id`, `payment` FROM `MyExp_Payments` ORDER BY `payment` ASC;";
  
  if ($result = mysqli_query($con, $selectSql)) {
    $resultArray = array();
    $tempArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray, $tempArray);
    }
    
    header('Content-Type: application/json');
    $data = array('data' => $resultArray);
    echo json_encode($data);
  }
  else {
    echo "no data back";
  }
}
else {
  echo "not POST method";
}

mysqli_close($con);
?>
