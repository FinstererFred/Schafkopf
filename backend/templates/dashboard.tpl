{extends file="index.tpl"}

{block name="page-content"}
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Dashboard</h1>
  </div>
</div>

<div class="row">
	<div class="col-lg-8 col-md-12">
		<div class="col-lg-6">
			<div class="panel panel-primary">
				<div class="panel-heading">
					<div class="row">
						<div class="col-xs-3">
							<i class="fa fa-th fa-5x"></i>
						</div>
						<div class="col-xs-9 text-right">
							<div class="huge">{$tischCount}</div>
							<div>Tische</div>
						</div>
					</div>
				</div>
				<a href="tische.php">
					<div class="panel-footer">
						<span class="pull-left">Details</span>
						<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
						<div class="clearfix"></div>
					</div>
				</a>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="panel panel-green">
				<div class="panel-heading">
					<div class="row">
						<div class="col-xs-3">
							<i class="fa fa-users fa-5x"></i>
						</div>
						<div class="col-xs-9 text-right">
							<div class="huge">{$spielerCount}</div>
							<div>Spieler</div>
						</div>
					</div>
				</div>
				<a href="spieler.php">
					<div class="panel-footer">
						<span class="pull-left">Details</span>
						<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
						<div class="clearfix"></div>
					</div>
				</a>
			</div>
		</div>
		<!--
		<div class="col-lg-6">
			<div class="panel panel-yellow">
				<div class="panel-heading">
					<div class="row">
						<div class="col-xs-3">
							<i class="fa fa-qrcode fa-5x"></i>
						</div>
						<div class="col-xs-9 text-right">
							<div class="huge">{$tischCount}</div>
							<div>Spielarten</div>
						</div>
					</div>
				</div>
				<a href="offers.php">
					<div class="panel-footer">
						<span class="pull-left">Details</span>
						<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
						<div class="clearfix"></div>
					</div>
				</a>
			</div>
		</div>
		-->
		<div class="col-lg-6">
			<div class="panel panel-red">
				<div class="panel-heading">
					<div class="row">
						<div class="col-xs-3">
							<i class="fa fa-trophy fa-5x"></i>
						</div>
						<div class="col-xs-9 text-right">
							<div class="huge">{$spieleCount}</div>
							<div>Spiele</div>
						</div>
					</div>
				</div>
				<a href="lottery.php">
					<div class="panel-footer">
						<span class="pull-left">Details</span>
						<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
						<div class="clearfix"></div>
					</div>
				</a>
			</div>
		</div>

	</div>

<!--
	<div class="col-lg-4 col-md-12">

		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-pie-chart fa-fw"></i> Übersicht Händler je Aktion
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div id="chart-merchants-per-mandator"></div>
			</div>
			<!-- /.panel-body -->
		</div>

	</div>
-->
</div>


{/block}

{block name="footer_bottom_script" append}
<script type="text/javascript">


</script>
{/block}
