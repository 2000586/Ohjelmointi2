<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="scripts/main.js"></script>

<title>Lisää asiakas</title>
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

#takaisin {	cursor: pointer;
	font-weight: bold;
	color: black;
	text-decoration: none;
	font-family: Arial, Helvetica, sans-serif;
}
}
</style>
</head>
<body onkeydown="tutkiKey(event)">
	<form id="tiedot">
		<table>
			<thead>
				<tr>
					<th colspan="5" class="right"><a href="listaaasiakkaat.jsp" id="takaisin">Takaisin listaukseen</a></th>
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
					<td><input type="email" name="sposti" id="sposti"></td>
					<td><input type="button" id="tallenna" value="Lisää" onclick="lisaaTiedot()"></td>
				</tr>
			</tbody>
		</table>
	</form>
	<span id="ilmo"></span>
</body>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		lisaaTiedot();
	}
	
}

document.getElementById("etunimi").focus();

//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /autot/
function lisaaTiedot(){	
	var ilmo="";
	
	if(document.getElementById("etunimi").value.length<2){
		ilmo="Etunimi ei kelpaa!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi ei kelpaa!";		
	}else if(document.getElementById("puhelin").value.length<6){
		ilmo="Puhelinnumero ei kelpaa!";		
	}else if(document.getElementById("sposti").value.length<6){
		ilmo="Sposti ei kelpaa!";		
	}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	//Lähetään uudet tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen epäonnistui";
      	}else if(vastaus==1){	        	
      		document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}
	
	
</script>
</html>