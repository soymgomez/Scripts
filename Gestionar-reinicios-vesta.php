<html>
	<head>
		<title>Gestion de servicios <?php $_SERVER["HTTP_HOST"] ?></title>
	</head>
<body>

<?php
if (isset($_GET["reiniciar"])) {

	$accion = $_GET["reiniciar"];


	if ($accion == 'mysql') {
		$output = shell_exec('sudo /usr/local/vesta/bin/v-restart-mysqld');
		//$output = shell_exec('service mysqld restart');
		echo "<pre>$output</pre>";
		echo "Listo. Servidor Mysql reiniciado correctamente";
		$message = 'Servidor Mysql reiniciado correctamente';
	}

	if ($accion == 'nginx') {
		$output = shell_exec('sudo /usr/local/vesta/bin/v-restart-proxy');
		//$output = shell_exec('service nginx restart');
		echo "<pre>$output</pre>";
		echo "Listo. Servidor Nginx reiniciado correctamente";
		$message = 'Servidor Nginx reiniciado correctamente';
	}

	if ($accion == 'apache') {
		$output = shell_exec('sudo /usr/local/vesta/bin/v-restart-web');
		//$output = shell_exec('service httpd restart');
		echo "<pre>$output</pre>";
		echo "Listo. Servidor Apache reiniciado correctamente";
		$message = 'Servidor Apache reiniciado correctamente';
	}


	//Iniciamos LOG

	  // Get time of request
  		if( ($time = $_SERVER['REQUEST_TIME']) == '') {
    		$time = time();
  		}
 
  	// Get IP address
  		if( ($remote_addr = $_SERVER['REMOTE_ADDR']) == '') {
    		$remote_addr = "REMOTE_ADDR_UNKNOWN";
  		}
 
  	// Get requested script
  		if( ($request_uri = $_SERVER['REQUEST_URI']) == '') {
    		$request_uri = "REQUEST_URI_UNKNOWN";
  		}
 
  	// Format the date and time
  		$date = date("Y-m-d H:i:s", $time);

  	$logfile = '/home/admin/web/gestion.laverdadnoticias.com/public_html/registro.log';

  	if($fd = @fopen($logfile, "a")) {
    	$result = fputcsv($fd, array($date, $remote_addr, $message));
    fclose($fd);
	}

echo '<br/><a href="/">Volver</a>';
}else{
echo '<ul>
	<li><a href="/?reiniciar=mysql">Reiniciar Mysql</a></li>
	<li><a href="/?reiniciar=nginx">Reiniciar Nginx</a></li>
	<li><a href="/?reiniciar=apache">Reiniciar Apache</a></li>
</ul>';

}
?>
</body>
</html>