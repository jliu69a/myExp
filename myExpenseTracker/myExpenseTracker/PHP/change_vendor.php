<?php
//http://www.mysohoplace.com/php_hdb/php_GL/prod/change_vendor.php

// Create connection
include('connection_header.php');

if ($_POST) {
  $id = mysqli_real_escape_string($con, $_POST['id']);
  $name = mysqli_real_escape_string($con, $_POST['name']);
  $isEdit = mysqli_real_escape_string($con, $_POST['edit']);
  
  $name = str_replace("&amp;", "&", $name);
  
  $insertSql = "INSERT INTO `MyExp_Venders` (`vendor`) VALUES ('$name');";
  $updateSql = "UPDATE `MyExp_Venders` SET `vendor`='$name' WHERE `id`=$id;";
  $deleteSql = "DELETE FROM `MyExp_Venders` WHERE `id`=$id;";
  
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
  
  $selectSql = "SELECT `id`, `vendor` FROM `MyExp_Venders` ORDER BY `vendor` ASC;";
  $resultArray = array();
  
  if ($result = mysqli_query($con, $selectSql)) {
    $tempArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray, $tempArray);
    }
  }
  
  $currentYear = date('Y');
  $top10Sql = "SELECT a.vendor_id AS 'id', b.vendor AS 'vendor', COUNT(a.vendor_id) AS 'total' FROM MyExp_Data a, MyExp_Venders b WHERE a.vendor_id = b.id AND date LIKE '$currentYear%' GROUP BY `vendor_id` ORDER BY `total` DESC LIMIT 10;";
  $resultArray2 = array();
  
  if ($result = mysqli_query($con, $top10Sql)) {
    $tempArray = array();
    
    while($row = $result->fetch_object()) {
      $tempArray = $row;
      array_push($resultArray2, $tempArray);
    }
  }
  
  header('Content-Type: application/json');
  $data = array('vendor' => $resultArray, "top10" => $resultArray2);
  echo json_encode($data);
}
else {
  echo "not POST method";
}

mysqli_close($con);
?>
