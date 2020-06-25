<?php
error_reporting(0);
include_once ("dbconnect.php");
$category = $_POST['category'];
$name = $_POST['name'];

if (isset($category)){
    if ($category == "RECENT"){
        $sql = "SELECT * FROM PRODUCT ORDER BY NAME DESC lIMIT 20";    
    }else{
        $sql = "SELECT * FROM PRODUCT WHERE CATEGORY = '$category'";    
    }
}else{
    $sql = "SELECT * FROM PRODUCT ORDER BY NAME DESC lIMIT 20";    
}
if (isset($name)){
   $sql = "SELECT * FROM PRODUCT WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["name"] = $row["NAME"];
        $productlist["id"] = $row["ID"];
        $productlist["price"] = $row["PRICE"];
        $productlist["calories"] = $row["CALORIES"];
        $productlist["ingredient"] = $row["INGREDIENT"];
        $productlist["category"] = $row["CATEGORY"];
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>