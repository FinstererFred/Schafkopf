{include file='header.tpl'}

{block name="page-content"}

<div>
    <div class="col-lg-6 col-centered" >
    	<div class="row">
    		<div class="col-md-6 vcenter"><img src="gfx/logo.png" /></div><div class="col-md-6 text-right vcenter">
				<select id="tische">
					<option>Disch assucha</option>
				</select>
				<a href="logout.php">logout</a>
    		</div>
    	</div>

    	<div class="row">
    		<div class="col-md-12 inputBox neuesSpiel">
    			<h3>Neis Spui</h3>
    			<table width ="100%" class="inputTable">
    				<tr>
    					<th>Spui-Typ</th>
    					<th width="160">Spuia</th>
    					<th width="130">Kosdn</th>
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
		<br/>
		<div class="row">
			<div class="col-md-12 graf">
			<button onclick="doGraf()" >Graf ozeign</button><br/>
			<div id="placeholder" style="width: 800px;height: 450px;" class="demo-placeholder"></div>
			</div>
		</div>
	</div>
</div>


<script src="js/jquery-2.2.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="backend/bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
<script src="backend/bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"></script>
<script src="backend/bower_components/bootstrap-select-1.10.0/dist/js/bootstrap-select.min.js"></script>
<script src="backend/bower_components/flot/jquery.flot.js"></script>

<script type="text/javascript">
	var spieler=[];
	var tisch;
	var typen;
	var loggedinUser = {$loggedinUser};
	var offen = '';

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
			getTisch($(this).val());
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
					$('#kosten').blur();
					getListe();
					getSumme();
					$('.doppelt input:checked:last').prop('checked',false);
				}
			});
		});
		

		$('#tbody2').on('click', '.showDayDetail', function()  {
			var _date = $(this).data('date')

			$('.hideMe').remove();
			
			if(offen == _date ) {
				offen = '';
				return;
			}

			var that = $(this);
			$.ajax({
				url: 'controller/ajax.php?action=getListe',
				data: { 'id' : $('#tische').val(), 'rnd' : Math.random(), 'date': $(this).data('date') },
				dataType:'json'
			})
			.done(function(data) {
				var out = '';
				for(var i in data) {
					out += '<tr class="hideMe"><td class="spielName">'+data[i]['name']+'</td>';
					for(var j in data[i]['erg'])
					{
						class_name = 'loser';
						if (data[i]['erg'][j].gewinn > 0) { class_name = 'winner'; }
						out+='<td align="right" class="'+class_name+'">'+data[i]['erg'][j].gewinn+' <span class="spielerID">('+j+')</span></td>';
					}
					out += '</tr>';
				}
				$(out).insertAfter( $(that).parent() );
				offen = _date;
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


				out += '<tr><td class="showDayDetail" data-date="'+formatDate(i)+'">'+i+'</td>';
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

	function formatDate(date) {
		date = date.split('-');
		return date[2]+'.'+date[1]+'.'+date[0];
	}

	function shortCuts() {
		$('body').off();

		$('body').keyup(function(e){
			console.log(e.keyCode);
			if(e.keyCode == 16) {
				$('.doppelt input:not(:checked):first').prop('checked',true);
				return false;
			}

			if(e.keyCode == 49) {

				if(!$("#kosten").is(":focus")) {
					$('#spielTyp li:nth-child(1) input').prop('checked',true);

				}
			}

			if(e.keyCode == 50) {
				if(!$("#kosten").is(":focus")) {
					$('#spielTyp li:nth-child(2) input').prop('checked',true);
					
				}
			}

			if(e.keyCode == 51) {
				if(!$("#kosten").is(":focus")) {
					$('#spielTyp li:nth-child(3) input').prop('checked',true);
				}
			}

			if(e.keyCode == 52) {
				if(!$("#kosten").is(":focus")) {
					$('#spielTyp li:nth-child(4) input').prop('checked',true);

				}
			}

			if(e.keyCode == 53) {
				if(!$("#kosten").is(":focus")) {
					$('#spielTyp li:nth-child(5) input').prop('checked',true);
				}
			}

			if(e.keyCode == 81) {
				$('#spieler li:nth-child(1)').toggleClass('gewinner');
			}

			if(e.keyCode == 87) {
				$('#spieler li:nth-child(2)').toggleClass('gewinner');
			}

			if(e.keyCode == 69) {
				$('#spieler li:nth-child(3)').toggleClass('gewinner');
			}

			if(e.keyCode == 82) {
				$('#spieler li:nth-child(4)').toggleClass('gewinner');
			}

			if(e.keyCode == 65) {
				$('#kosten').focus();
			}
		});
	}

	function doGraf() {
		$.ajax({
			url: 'controller/ajax.php',
			data: {'action' : 'getDayList', 'id' : tisch.id, 'spielerID' : 0, 'reverse' : true},
			dataType: "json"
		})
		.done(function(data) {
			var sp = {};
			var ins = 0;
			var sptag = '';

			for(var i in data) {
				if(sptag != i) { ins++;}

				if(typeof(sp[0]) == 'undefined') { sp[0] = {'id' : data[i][0].id, 'data' : [] }; }
				if(typeof(sp[1]) == 'undefined') { sp[1] = {'id' : data[i][1].id, 'data' : [] }; }
				if(typeof(sp[2]) == 'undefined') { sp[2] = {'id' : data[i][2].id, 'data' : [] }; }
				if(typeof(sp[3]) == 'undefined') { sp[3] = {'id' : data[i][3].id, 'data' : [] }; }

				var gewinn0 = data[i][0].gewinn + offset[1][data[i][0].id];
				var gewinn1 = data[i][1].gewinn + offset[1][data[i][1].id];
				var gewinn2 = data[i][2].gewinn + offset[1][data[i][2].id];
				var gewinn3 = data[i][3].gewinn + offset[1][data[i][3].id];

				sp[0].data.push( [ins, gewinn0] );
				sp[1].data.push( [ins, gewinn1] );
				sp[2].data.push( [ins, gewinn2] );
				sp[3].data.push( [ins, gewinn3] );
			}
			
			$.plot("#placeholder", [ 
				{ data:sp[0].data, label: spieler[sp[0].id].kurz},
				{ data:sp[1].data, label: spieler[sp[1].id].kurz}, 
				{ data:sp[2].data, label: spieler[sp[2].id].kurz}, 
				{ data:sp[3].data, label: spieler[sp[3].id].kurz} ],
			{
				series: {
					lines: { show: true },
					points: { show: true }
				},
				grid: {
					hoverable: true, clickable: false,
					markings: [ { color: '#ff0000', lineWidth: 1, yaxis: { from: 0, to: 0 } }, ]
				},
				xaxis:{
          			tickSize : 1
       			}
			});
		});
	}

	function getTisch(id) {
			$.ajax({
				url: 'controller/ajax.php',
				data: {'action' : 'getTisch', 'id' : id, 'rnd' : Math.random() },
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
				shortCuts();
			});
	}


	$("#placeholder").bind("plothover", function (event, pos, item) {
			if (item) {
				
					var str = (item.datapoint[1] / 100).toFixed(2) + ' Euro';
					
					$("#tooltip").html(str)
						.css({top: item.pageY+5, left: item.pageX+10})
						.fadeIn(200);
				} else {
					$("#tooltip").hide();
				}

		});

	$("<div id='tooltip'></div>").css({
				position: "absolute",
				display: "none",
				border: "1px solid #fdd",
				padding: "2px",
				"background-color": "#fee",
				opacity: 0.80
			}).appendTo("body");
{/literal}
</script>

{/block}
{include file='footer.tpl'}