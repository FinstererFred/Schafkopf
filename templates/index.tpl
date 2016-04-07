{include file='header.tpl'}

{block name="page-content"}
<a href="logout.php">logout</a>
<div>
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
    			<table width ="100%" class="inputTable">
    				<tr>
    					<th>Spiel-Typ</th>
    					<th width="160">Spieler</th>
    					<th width="130">Kosten</th>
    					<th width="30"></th>
    					<th></th>
    					<th>Doppelt</th>
    				</tr>

    				<tr>
    					<td valign="top"><ul id="spielTyp"></ul></td>
    					<td valign="top"><ul id="spieler"></ul></td>
    					<td valign="top"><input type="tel" class="form-control" id="kosten" /></td>
    					<td valign="top"></td>
    					<td valign="top"><button type="button" id="save" class="btn btn-default btn-sm">
							  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Speichern
							</button>
						</td>
						<td valign="top" class="doppelt">
    						<input  type="checkbox">
    						<input  type="checkbox">
    						<input  type="checkbox">
    						<input  type="checkbox">
    					</td>
    				</tr>

    			</table>
    		</div>
    </div><br/>
		<div class="row">
			<div class="col-md-12 inputBox"><br/>
				<table class="table table-striped table-bordered table-hover" id="dataTables-example">
						<thead id="theader"></thead>
						<tbody id="summen"></tbody>
						<tbody id="tbody"></tbody>
				</table>
			</div>
		</div><br/>
		<div class="row">
			<div class="col-md-12 inputBox"><br/>
				<table class="table table-striped table-bordered table-hover" id="dataTables2">
						<thead id="theader2">
		    				<tr>
		    					<th width="130">Datum</th>
		    					<th></th>
		    					<th></th>
		    					<th></th>
		    					<th></th>
    						</tr>
    					</thead>
						<tbody id="summen2"></tbody>
						<tbody id="tbody2"></tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<script src="js/jquery-2.2.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="backend/bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
<script src="backend/bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"></script>
<script src="backend/bower_components/bootstrap-select-1.10.0/dist/js/bootstrap-select.min.js"></script>


<script type="text/javascript">
	var spieler=[];
	var tisch;
	var typen;
	var loggedinUser = {$loggedinUser};
{literal}
	var offset = {1: {1:-25, 3:-1580, 4:860, 5:745}};

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
				data: {'action' : 'getTisch', 'id' : $(this).val(), 'rnd' : Math.random() },
				dataType: "json"
			})
			.done(function(data) {

				data = data[0];
				var out = '<tr><th width="130"></th>';
				for(var i in data.spieler) {
					spieler[data.spieler[i].id] = data.spieler[i];
					out += "<th>"+data.spieler[i].kurz+" <span class=\"spielerID\">("+data.spieler[i].id+")</span></th>";
				}
				out += '<th width="20px"></th>';
				out += "</tr>";
				$('#theader').html(out);

				tisch = data.tisch;

				var outSpieler = '';
				outSpieler+= '<li data-id="'+spieler[tisch.sp1].id+'">'+spieler[tisch.sp1].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp2].id+'">'+spieler[tisch.sp2].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp3].id+'">'+spieler[tisch.sp3].kurz+'</li>';
				outSpieler+= '<li data-id="'+spieler[tisch.sp4].id+'">'+spieler[tisch.sp4].kurz+'</li>';

				$('#spieler').html(outSpieler);

				getListe();
				getSumme();
				getDayList();
			});
		});

		$('#spieler').on('click', 'li', function() {
			$(this).toggleClass('gewinner');
		});

		$('#kosten').keypress(function (e) {
		  if (e.which == 13) {
		  	$( "#save" ).trigger( "click" );
		  }
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
					getListe();
					getSumme();
					$('.doppelt input:checked:last').prop('checked',false);
				}

			});
		});
		
	});

	function getSumme() {
		$.ajax({
			url: 'controller/ajax.php?action=getSummen',
			data: { 'id' : $('#tische').val(), 'rnd' : Math.random() }, 
			dataType : 'json'
		})
		.done(function(data) {
			var out = '<tr><td><b>Summe</b></td>';
			

			for(var i in data) {
				
				var summe = parseInt(data[i]);

				if(typeof(offset[tisch.id]) != 'undefined') {
					summe += offset[tisch.id][i];
				}

				summe = summe / 100;

				out +="<td align='right'>"+summe.toFixed(2)+" <span class=\"spielerID\">("+i+")</span></td>";
			}
			out += '<td></td>';
			out += '</tr>';
		
			$('#summen').html(out);
		});


	}

	function getListe() {
		$.ajax({
			url: 'controller/ajax.php?action=getListe',
			data: { 'id' : $('#tische').val(), 'rnd' : Math.random() },
			dataType:'json'
		})
		.done(function(data) {
			var out = '';
			for(var i in data) {
				out += '<tr><td>'+data[i]['name']+'</td>';
				for(var j in data[i]['erg'])
				{
					class_name = 'loser';
					if (data[i]['erg'][j].gewinn > 0) { class_name = 'winner'; }
					out+='<td align="right" class="'+class_name+'">'+data[i]['erg'][j].gewinn+' <span class="spielerID">('+j+')</span></td>';
				}
				out += '<td><a href="#" data-toggle="popover" data-content="Löschen" class="deleteGame" data-id="'+i+'"><i class="fa fa-close"></i></a></td>';
				out += '</tr>';
			}
			$('#tbody').html(out);
			
			$('[data-toggle="popover"]').popover(); 

			$('.deleteGame').click(function() {
				gameID = parseInt($(this).data('id').replace('s', ''));
				$('.popover-content').click(function() {
					$.ajax({
						url: 'controller/ajax.php?action=deleteGame',
						data: { 'id' : gameID, 'rnd' : Math.random() },
						dataType:'json'
					})
					.done(function() {
						getListe();
						getSumme();
					});
				});
			});
			
		});


	}

	function getDayList() {
		$.ajax({
			url: 'controller/ajax.php?action=getDayList',
			data: { 'id' : $('#tische').val(), 'rnd' : Math.random() },
			dataType:'json'
		})
		.done(function(data) {
			var out = '';
			for(var i in data) {

				out += '<tr><td>'+i+'</td>';
				for(var j in data[i])
				{
					gewinn = data[i][j].gewinn;
					if(typeof(offset[tisch.id]) != 'undefined') {
						gewinn += offset[tisch.id][data[i][j].id];
					}	
					gewinn = gewinn / 100;
					out+='<td align="right">'+gewinn.toFixed(2)+' <span class="spielerID">('+data[i][j].id+')</span></td>';
				}
				out += '</tr>';
				
			}
			$('#tbody2').html(out);
		});
	}

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

{/literal}
</script>

{/block}
{include file='footer.tpl'}