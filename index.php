<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>Schafkopf</title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" media="screen" href="css/style.css" />
	</head>
<body>
 


<div class="row">
    <div class="col-md-6 col-centered" >
    	<div class="row">
    		<div class="col-md-6 vcenter"><h2>Schafkopf</h2></div><!--
    	--><div class="col-md-6 text-right vcenter">
				<select id="tische">
					<option>Tisch auswählen</option>
				</select>
    		</div>
    	</div>

    	<div class="row">
    		<div class="col-md-12 inputBox">
    			<h3>Neues Spiel</h3>
    			<table width ="100%">
    				<tr>
    					<th>Spiel-Typ</th>
    					<th width="160">Spieler</th>
    					<th width="130">Kosten</th>
    					<th width="30"></th>
    					<th></th>
    				</tr>

    				<tr>
    					<td valign="top"><ul id="spielTyp"></ul></td>
    					<td valign="top"><ul id="spieler"></ul></td>
    					<td valign="top"><input type="text" class="form-control" id="kosten" /></td>
    					<td valign="top"></td>
    					<td valign="top"><button type="button" id="save" class="btn btn-default btn-sm">
							  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Speichern
							</button>
						</td>
    				</tr>

    			</table>
    		</div>
    </div>
</div>



<script src="js/jquery-2.2.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>

<script type="text/javascript">
	var spieler=[];
	var tisch;
	var typen;
	var loggedinUser = 3;	

	$(function () {
		$.ajax({
			url: 'controller/ajax.php', 
			data: {'action' : 'getTypen'}, 
			dataType: "json"
		})
		.done(function(data) {
			var out = '';
			typen = data;
			for(var i in data) {
				out+='<li><input type="radio" name="spieltyp" id="typ_'+data[i].id+'" value="'+data[i].id+'"><label for="typ_'+data[i].id+'"> '+data[i].name+'</li>';
			}
			$('#spielTyp').html(out);
		});

		$.ajax({
			url: 'controller/ajax.php', 
			data: {'action' : 'getTische', 'id' : loggedinUser}, 
			dataType: "json"
		})
		.done(function(data) {
			var out = '';
			for(var i in data) {
				out+= '<option value="'+data[i].id+'">'+data[i].name+'</option>';
			}
			$('#tische').append(out);
		});

		$('#tische').on('change', function() {
			$.ajax({
				url: 'controller/ajax.php',
				data: {'action' : 'getTisch', 'id' : $(this).val() },
				dataType: "json"
			})
			.done(function(data) {
				
				data = data[0];
				for(var i in data.spieler) {
					spieler[data.spieler[i].id] = data.spieler[i];
				}
				tisch = data.tisch;

				var outSpieler = '';
				outSpieler+= '<li data-id="'+spieler[tisch.sp1].id+'">'+spieler[tisch.sp1].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp2].id+'">'+spieler[tisch.sp2].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp3].id+'">'+spieler[tisch.sp3].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp4].id+'">'+spieler[tisch.sp4].kurz+'</li>';

				$('#spieler').html(outSpieler);
			});
		});

		$('#spieler').on('click', 'li', function() {
			$(this).toggleClass('gewinner');
		});

		$('#save').on('click', function() {
			
			var game = {};
			game.winner = [];
			$('#spieler li').each(function() {
				gewinner = 0;
				if( $(this).hasClass('gewinner') ) {
					gewinner = 1;
				}

				game.winner.push( { 'spielerID' : $(this).data('id') , 'gewinner' : gewinner } );
			});

			game.preis = $('#kosten').val();
			game.typID = $('input[name=spieltyp]:checked').val();
			game.tischID = $('#tische').val();
			game.timestamp = getTime();

			$.ajax({
				url: 'controller/ajax.php?action=saveGame',
				data: { 'data' : JSON.stringify(game)},
				
				method: "POST"

			})
			.done(function(data) {
			
				if(data === 'ok') {
					$('#spieler li').removeClass('gewinner');
					$('#kosten').val('');
				}
			});
		});
	});

	function getTime() {
		var date = new Date();
		var day = date.getDate();
		var monthIndex = date.getMonth();
		var year = date.getFullYear();
		var hours = date.getHours();
		var minutes = date.getMinutes();
		var seconds = date.getSeconds();

		return year+'-'+(monthIndex+1)+'-'+day+' '+hours+':'+minutes+':'+seconds;
	}
	
</script> 

</body>
</html>