{extends file="index.tpl"}

{block name="page-content"}
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Tische</h1>
  </div>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                Aktionen - Übersicht
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="dataTable_wrapper">
                    <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                        <thead>
                            <tr>
                                <th>id</th>
                                <th>Name</th>
                                <th>Sp1</th>
                                <th>Sp2</th>
                                <th>Sp3</th>
                                <th>Sp4</th>
                                <th width="20"></th>
                            </tr>
                        </thead>
                    </table>
                </div>

            </div>
            <!-- /.panel-body -->
        </div>
        <button type="button" class="btn btn-info" id="newObject">Neuen Tisch anlegen</button>

        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>

<!-- Modal -->
<div id="addObject" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Neuer Tisch</h4>
      </div>
      <div class="modal-body">
        <div class="row">

          <div class="col-lg-12">
          <form id="mandatorForm" class="editForm" role="form">
            <div class="form-group row">
              <label for="inputEmail3" class="col-sm-3 form-control-label">Name</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="inputName" placeholder="Name">
              </div>
            </div>

						<div class="form-group row">
							<label for="inputType" class="col-sm-3 form-control-label">Spieler 1</label>
							<div class="col-sm-8">
								<select id="inputSp1" class="selectpicker">
									{foreach $spieler as $spieleR}
										<option value="{$spieleR.id}">{$spieleR.name}</option>
									{/foreach}
								</select>
							</div>
						</div>

						<div class="form-group row">
							<label for="inputType" class="col-sm-3 form-control-label">Spieler 2</label>
							<div class="col-sm-8">
								<select id="inputSp2" class="selectpicker">
									{foreach $spieler as $spieleR}
										<option value="{$spieleR.id}">{$spieleR.name}</option>
									{/foreach}
								</select>
							</div>
						</div>

						<div class="form-group row">
							<label for="inputType" class="col-sm-3 form-control-label">Spieler 3</label>
							<div class="col-sm-8">
								<select id="inputSp3" class="selectpicker">
									{foreach $spieler as $spieleR}
										<option value="{$spieleR.id}">{$spieleR.name}</option>
									{/foreach}
								</select>
							</div>
						</div>

						<div class="form-group row">
							<label for="inputType" class="col-sm-3 form-control-label">Spieler 4</label>
							<div class="col-sm-8">
								<select id="inputSp4" class="selectpicker">
									{foreach $spieler as $spieleR}
										<option value="{$spieleR.id}">{$spieleR.name}</option>
									{/foreach}
								</select>
							</div>
						</div>

						<div class="form-group row">
							<label for="inputType" class="col-sm-3 form-control-label">Verantwortlicher</label>
							<div class="col-sm-8">
								<select id="inputVerantwortlicher" class="selectpicker">
									{foreach $spieler as $spieleR}
										<option value="{$spieleR.id}">{$spieleR.name}</option>
									{/foreach}
								</select>
							</div>
						</div>

          </form>

          </div>

        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Abbrechen</button>
        <button type="button" class="btn btn-info" id="confirmBtn" data-action="new">Anlegen</button>
      </div>
    </div>

  </div>
</div>
<script type="text/javascript">
  var objects = {$objectsJSON};
  var activeObject = -1;
  var objectType = 'tische';
</script>
{/block}

{block name="footer_bottom_script" append}
  <script type="text/javascript">

    var table = $('#dataTables-example').DataTable({
          language: {
                "url": "bower_components/datatables/media/js/German.json"
            },
       ajax: "../controller/ajax.php?action=getAllTische",
       responsive: true,
       columnDefs: [
         { targets: [4, 5], sortable: false},
         { targets: [0], visible:false}

       ],
       columns: [
          { data: "id"},
          { data: "name" },
          { data: "sp1" },
          { data: "sp2" },
          { data: "sp3" },
          { data: "sp4" },
          {
              data: null,
              className: "center",
              "render": function ( row, data, index ) {
                return '<i class="fa fa-pencil" data-objectid="'+row.id+'"></i>&nbsp;&nbsp;<i class="fa fa-trash" data-objectid="'+row.id+'"></i>';
              }
          }
      ],
      fnDrawCallback: function( oSettings ) {
        if(typeof(oSettings.json) != 'undefined') {
          //console.log( oSettings.json.data) ;
          objects = oSettings.json.data;
        }
      }
    });

  $('#inputStartdate').datepicker(
  	{
  	    format: "dd.mm.yyyy",
  	    todayBtn: "linked",
  	    language: "de",
  	    todayHighlight: true,
  	    orientation: "bottom",
         autoclose: true
  	});

    $('#inputEnddate').datepicker(
    	{
    	    format: "dd.mm.yyyy",
    	    todayBtn: "linked",
    	    language: "de",
    	    todayHighlight: true,
    	    orientation: "bottom",
           autoclose: true
    	});

  </script>
{/block}
