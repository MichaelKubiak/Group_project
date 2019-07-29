<?php
//ini_set('memory_limit', '-1');
Receptor: $_POST['genes']; 
$input_k = $_POST['k_values'];
$sort_val = $_POST['sorting'];

// connect
$connection = db_connect();

// security on user query
$input_gene = mysqli_real_escape_string($connection, $_POST['genes']);
// define SQL
$sql_format = "SELECT cell_id, gene_expr, %s, cell_type, tissue, donor_age FROM alldata WHERE gene_id='%s' ORDER BY gene_expr %s";
//SELECT cell_id, gene_expr, clust_7, cell_type, tissue, donor_age FROM alldata WHERE gene_id='PLP1' ORDER BY gene_expr DESC;
$sql = sprintf($sql_format,$input_k,$input_gene,$sort_val);



$result = mysqli_query($connection,$sql);
// Attempt select query execution
if($result = mysqli_query($connection, $sql)){
   if(mysqli_num_rows($result) > 0){
      echo "<table border='1' style='font-family:sans-serif;'>";
         echo "<tr>";
            echo "<th>Cell ID</th>";
            echo "<th>Expression Level</th>";
            echo "<th>Cluster Assignment</th>";
            echo "<th>Cell Type</th>";
            echo "<th>Tissue</th>";
            echo "<th>Donor Age</th>";
         echo "</tr>";
      while($row = mysqli_fetch_array($result)){
         echo "<tr>";
            echo "<td style='text-align:center;'>" . $row['cell_id'] . "</td>";
            echo "<td style='text-align:center;'>" . $row['gene_expr'] . "</td>";
            echo "<td style='text-align:center;'>" . $row[$input_k] . "</td>";
            echo "<td style='text-align:center;'>" . $row['cell_type'] . "</td>";
            echo "<td style='text-align:center;'>" . $row['tissue'] . "</td>";
            echo "<td style='text-align:center;'>" . $row['donor_age'] . "</td>";
         echo "</tr>";
      }
      echo "</table>";
      // Free result set
      mysqli_free_result($result);
   } 
   else{
        echo "No records matching your query were found.";
   }
} 
else{
    echo "ERROR: Could not execute $sql. " . mysqli_error($connection);
}



function db_connect() {
   //static variable, avoid multiple connections
   static $connection;
	
   // connect unless connection exists
   if(!isset($connection)) {
      // load config data
      $config = parse_ini_file('PHPsdhfoHF.ini');	
      // Try and connect to the database
      $connection = mysqli_connect('localhost',$config['username'],$config['password'],$config['dbname']);
       
   }
   // If connection was not successful, handle the error
   if($connection === false) {
      // Handle error 
       echo "connection fail<br>";
      return mysqli_connect_error();	
   }
   return $connection;
}


?>
