{include file='header.tpl'}

{block name="page-content"}
<div class="container">
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<div class="login-panel panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Login</h3>
				</div>
				<div class="panel-body">

						<fieldset>
							<div class="form-group">
							{if isset($template) && $template == 'overview'}
								<form action="overview.php" method="post">
							{else}
								<form action="index.php" method="post">
							{/if}
								<input class="form-control" placeholder="Benutzername" name="username" type="text" autofocus>
							</div>
							<div class="form-group">
								<input class="form-control" placeholder="Passwort" name="password" type="password" value="">
							</div>
							<div class="checkbox">
							</div>
							<!-- Change this to a button or input when using this as a form -->
							<input type="submit" class="btn btn-lg btn-success btn-block" value="Login">
							
						</fieldset>
					</form>
					<br />
					{if $message == "error"}
						<div class="alert alert-danger" id="login-error">
								Fehler beim Login!<br />Bitte prüfen Sie Ihre Zugangsdaten.
						</div>
					{/if}{if $message == "logout"}	
						<div class="alert alert-info" id="login-logout">
								Erfolgreich ausgelogt.
						</div>
					{/if}	
				</div>
			</div>
		</div>
	</div>
</div>

{/block}
