{extends file="index.tpl"}

{block name="page-content"}
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Spieler</h1>
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
                                <th>Kurz</th>
                                <th>password</th>
                                <th width="20"></th>
                            </tr>
                        </thead>
                    </table>
                </div>

            </div>
            <!-- /.panel-body -->
        </div>
        <button type="button" class="btn btn-info" id="newObject">Neuen Spieler anlegen</button>

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
        <h4 class="modal-title">Neuer Spieler</h4>
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
							<label for="inputEmail3" class="col-sm-3 form-control-label">Kurz</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="inputKurz" placeholder="Kurz">
							</div>
						</div>

						<div class="form-group row">
							<label for="inputEmail3" class="col-sm-3 form-control-label">Password</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" id="inputPassword" placeholder="Passwort">
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
  var objectType = 'spieler';
</script>
{/block}

{block name="footer_bottom_script" append}
  <script type="text/javascript">

    var table = $('#dataTables-example').DataTable({
          language: {
                "url": "bower_components/datatables/media/js/German.json"
            },
       ajax: "../controller/ajax.php?action=getAllSpieler",
       responsive: true,
       columnDefs: [
         { targets: [2], sortable: false},
         { targets: [0], visible:false}

       ],
       columns: [
          { data: "id"},
          { data: "name" },
          { data: "kurz" },
          { data: "password" },
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
