function formatDate(sDate) {
  pad = '00';
  sDate = (pad + sDate.getDate()).slice(-pad.length)+'.'+
  (pad + sDate.getMonth()).slice(-pad.length)+'.'+
  sDate.getFullYear();

  return sDate;
}

function ucwords(str) {
  return (str + '')
    .replace(/^([a-z\u00E0-\u00FC])|\s+([a-z\u00E0-\u00FC])/g, function($1) {
      return $1.toUpperCase();
    });
}

String.prototype.lowercaseFirstLetter = function() {
    return this.charAt(0).toLowerCase() + this.slice(1);
};

$(function() {

	$('body').on('click','.fa-trash', function() {
		var id = $(this).data('objectid');


		if (confirm("Löschen?")) {
			$.ajax({
					url:'../controller/ajax.php?action=delete',
					method: 'POST',
					data: { 'type': objectType, 'id' : id }
			} )
			.done(function(data) {
				if(data == true) {
					table.ajax.reload();
				} else {
					alert(data);
				}
			 });
		 }
	});

$('body').on('click','.fa-pencil', function() {
	var objectID = $(this).data('objectid');

	var index = -1;
	for(var i in objects) {
		if(objects[i].id == objectID) {
			index = i;
			break;
		}
	}
	activeObject = index;

	for(var varName in objects[index]) {

		if(  $('#input'+ucwords(varName)).prop('nodeName') == 'SELECT') {
			$('#input'+ucwords(varName)).val(objects[index][varName]+'').selectpicker('refresh');
		} else {
			if($('#input'+ucwords(varName)).attr('type') == 'text') {
				$('#input'+ucwords(varName)).val(objects[index][varName]);
			} else if(  $('#input'+ucwords(varName)).prop('nodeName') == 'TEXTAREA') {
				$('#input'+ucwords(varName)).val(objects[index][varName]);
			}
			 else {
				$('#input'+ucwords(varName)).prop('checked', objects[index][varName] == 1 ? true : false);
			}
		}

	}

		$('#confirmBtn').text('Speichern');
		$('#confirmBtn').data('action', 'save');
		$('#addObject').modal('show');
	});

	$('#newObject').on('click', function() {

		$('.editForm input').each(function() {
			$(this).val('');
		});

		$('#confirmBtn').text('Anlegen');
		$('#confirmBtn').data('action', 'new');
		$('#addObject').modal('show');
	});

	$('#confirmBtn').on('click', function() {
    var action = $(this).data('action');
    var error = false;

    if(action == 'save') {
      var object = objects[activeObject];

      for(var i in object) {
        if(i != 'id' && i != 'mandatorID'&& i != 'merchantID' ) {

          if($('#input'+ucwords(i)).attr('type') == 'text') {
            object[i] = $('#input'+ucwords(i)).val();
          }
		  else if ($('#input'+ucwords(i)).prop('nodeName') == 'SELECT') {
            object[i] = $('#input'+ucwords(i)).val();
          }
			else if ($('#input'+ucwords(i)).prop('nodeName') == 'TEXTAREA') {
								object[i] = $('#input'+ucwords(i)).val();
					}
		  else {
            object[i] = $('#input'+ucwords(i)).prop('checked');
            if(object[i] === true) object[i] = 1; else object[i] = 0;
          }
        }
      }

      $.ajax({
          url:'../controller/ajax.php?action=save',
          method: 'POST',
          data: { 'type': objectType, 'data' : JSON.stringify(object) }
      } )
      .done(function(data) {
        if(data == true) {
          $('#addObject').modal('hide');
          table.ajax.reload();
        } else {
          alert('Fehler: '+data);
          $('#addObject').modal('hide');
        }
      });
    } else {


      var object = {};
      $('.editForm input, .editForm select').each(function() {

        var key = $(this).attr('id').replace('input', '').lowercaseFirstLetter();

		 if(key != 'id' && key != 'mandatorID'&& key != 'merchantID' ) {

          if($(this).attr('type') == 'text') {
            object[key] = $(this).val();
          }
		  else if ($(this).prop('nodeName') == 'SELECT') {
            object[key] = $(this).val();
          }
		  else {
            object[key] = $(this).prop('checked');
            if(object[key] === true) object[i] = 1; else object[i] = 0;
          }
        }

      });




      $.ajax({
          url:'../controller/ajax.php?action=new',
          method: 'POST',
          data: { 'type': objectType, 'data' : JSON.stringify(object) }
      } )
      .done(function(data) {
        if(data == true) {
          $('#addObject').modal('hide');
          table.ajax.reload();
        } else {
          alert('Fehler: '+data);
          $('#addObject').modal('hide');
        }
      });

    }
  });

});
