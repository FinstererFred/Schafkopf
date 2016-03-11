<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title></title>
	<link rel="stylesheet" type="text/css" media="screen" href="css/style.css" />
	<script type="text/javascript" src="js/jquery-2.2.1.min.js"></script>
</head>
<body>
 
 Hallo $loggedinUser, bitte deinen Tisch wählen:<br/>
<select id="tische">
	<option>Tisch auswählen</option>
</select>


<script type="text/javascript">
	var loggedinUser = 3;	

	$(function () {
		$.ajax({
			url: 'controller/ajax.php', 
			data: {'action' : 'getTische', 'id' : loggedinUser}, 
			dataType: "json"
		})
		.done(function(data) {
			var out = '';
			for(var i in data) {
				out+= '<option value="">'+data[i].name+'</option>';
			}
			$('#tische').append(out);
		});
	});
</script> 

</body>
</html>