{include file='header.tpl'}

{block name="page-content"}

<div>
    <div class="col-lg-6 col-centered" >
    	<div class="row">
    		<div class="col-md-6 vcenter"><img src="gfx/logo.png" /></div><div class="col-md-6 text-right vcenter">
    		<a href="logout.php">logout</a>
    		</div>
    	</div>

		<div class="row overview">
			<div class="col-md-12 inputBox">
				<h2>Übasicht vo olle Spuia</h2>
				<table width ="100%" class="table table-striped table-bordered table-hover" id="uebersicht">
				</table>
				<a href="index.php" class="btn btn-primary">Basst, etz werd wieda gspuit</a>
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
	var alleSpieler =[];
	var tisch;
	var typen;
	var loggedinUser = {$loggedinUser};
	var offen = '';
	var spiele=[];

{literal}

	$(function () {

		$.ajax({
			url: 'controller/ajax.php?action=getBannerSummen',
			data: { 'id' : 1, 'rnd' : Math.random() }, 
			dataType : 'json'
		})
		.done(function(data) 
		{
			var out = '<tr>';
			
			for(var i in data) 
			{
				var summe = parseInt(data[i]);
				summe = summe / 100;
				out += '<tr><td width="80"><strong>'+i+'</strong></td>';
				if (summe < 0)
					out +="<td><font color='#FF0000'>"+summe.toFixed(2)+"</font></td>";
				else if (summe > 0)
					out +="<td><font color='#01DF01'>"+summe.toFixed(2)+"</font></td>";
				else
					out +="<td>"+summe.toFixed(2)+"</td>";
				out +="</tr>";
			}
			$('#uebersicht').html(out);
		});

		var _spieler = [];
		var _out = '';
		var _day = 0;
		for(var i in spieler)
		{	
			if(typeof(spieler[i]) != 'undefined')
			{
			_spieler.push(spieler[i].id);
			}
		}	
		$.ajax({
			url: 'controller/ajax.php?action=getLastDayOverview',
			data: { 'anzahlTage' : 1, 'rnd' : Math.random() },
			dataType:'json'
		})
		.done(function(data) {
			console.log(data);			
		});


});

{/literal}



</script>


{/block}
{include file='footer.tpl'}