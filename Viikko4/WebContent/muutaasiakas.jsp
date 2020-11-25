<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="scripts/main.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<title>Muokkaa asiakasta</title>
<style>
table {
	border: 10px solid #2e2e2e;
	background-color: lightskyblue;
	font-family: Arial, Helvetica, sans-serif;
	max-width: 550px;
	width: 100%;
	margin: 10px;
	height: auto;
}

th {
	padding-top: 5px;
	text-align: left;
	padding-left: 5px;
}

td {
	padding-left: 5px;
}

input {
	font-family: Arial;
	float: left;
	display: inline-block;
	background-color: darkgrey;
}

.right {
	text-align: right;
}

#takaisin {
	cursor: pointer;
}
}
</style>
</head>
<body>
	<form id="tiedot">
		<table>
			<thead>
				<tr>
					<th colspan="5" class="right"><span id="takaisin">Takaisin
							listaukseen</span></th>
				</tr>
				<tr>
					<th>Etunimi</th>
					<th>Sukunimi</th>
					<th>Puhelin</th>
					<th>Sposti</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					
					<td><input type="text" name="etunimi" id="etunimi"></td>
					<td><input type="text" name="sukunimi" id="sukunimi"></td>
					<td><input type="text" name="puhelin" id="puhelin"></td>
					<td><input type="text" name="sposti" id="sposti"></td>
					<td><input type="submit" id="tallenna" value="Muuta"></td>
				</tr>
			</tbody>
		</table>
		<input type="hidden" name="asiakas_id" id="asiakas_id">
	</form>
	<span id="ilmo"></span>
</body>
<script>
	$(document).ready(function() {
		$("#takaisin").click(function() {
			document.location = "listaaasiakkaat.jsp";
		});
		
		//Haetaan muutettavan auton tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
		
		var asiakas_id = requestURLParam("id"); //Funktio löytyy scripts/main.js 	
		$.ajax({url:"asiakkaat/hae1/"+asiakas_id, type:"GET", dataType:"json", success:function(result){	
			
			$("#asiakas_id").val(result.asiakas_id);
			$("#etunimi").val(result.etunimi);	
			$("#sukunimi").val(result.sukunimi);
			$("#puhelin").val(result.puhelin);
			$("#sposti").val(result.sposti);
			
	    }});
		
		
		$("#tiedot").validate({
			rules : {
				asiakas_id : {
					required: true
				},
				
				etunimi : {
					required : true,
					minlength : 2
				},
				sukunimi : {
					required : true,
					minlength : 2
				},
				puhelin : {
					required : true,
					minlength : 9
				},
				sposti : {
					required : true,
					email : true
				}
			},
			messages : {
				etunimi : {
					required : "Puuttuu",
					minlength : "Liian lyhyt"
				},
				sukunimi : {
					required : "Puuttuu",
					minlength : "Liian lyhyt"
				},
				puhelin : {
					required : "Puuttuu",
					minlength : "Liian lyhyt"
				},
				sposti : {
					required : "Puuttuu",
					email : "Ei ole sähköpostiosoite"
				}
			},
			submitHandler : function(form) {
				paivitaTiedot();
			}
		});
	});
	
	
	function paivitaTiedot() {
		var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
		$.ajax({
			url : "asiakkaat",
			data : formJsonStr,
			type : "PUT",
			dataType : "json",
			success : function(result) { //result on joko {"response:1"} tai {"response:0"}       
				if (result.response == 0) {
					$("#ilmo").html("Asiakkaan muokkaus epäonnistui.");
				} else if (result.response == 1) {
					$("#ilmo").html("Asiakkaan muokkaus onnistui.");
					$("#asiakas_id").val("");
					$("#etunimi").val("");
					$("#sukunimi").val("");
					$("#puhelin").val("");
					$("#sposti").val("");
				}
			}
		});
	}
</script>
</html>