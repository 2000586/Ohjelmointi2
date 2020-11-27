<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title>Asiakaslistaus</title>
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
	border-top: 2px solid darkgrey;
}

input {
	font-family: Arial;
	float: left;
	display: inline-block;
	background-color: darkgrey;
}

.poista, .linkki {
	cursor: pointer;
	font-weight: bold;
	color: black;
	text-decoration: none;
	font-family: Arial, Helvetica, sans-serif;
}

.right {
	text-align: right;
}
}
</style>
</head>
<body onkeydown="tutkiKey(event)">
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="3"><span id="ilmo"> </span>
				<th colspan="5" class="right"><a class="linkki" id="uusiAsiakas" href="lisaaasiakas.jsp">Lisää uusi asiakas</a></th>
			</tr>
			<tr>


				<th colspan="1" class="right">Hakusana:</th>
				<th colspan="2"><input size="30" type="text" id="hakusana"></th>
				<th><input type="button" value="HAKU" id="hakunappi" onclick="haeTiedot()"></th>
			</tr>
			<tr>
				
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
				<th></th>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
	<script>
	haeTiedot();	
	document.getElementById("hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä

	function tutkiKey(event){
		if(event.keyCode==13){//Enter
			haeTiedot();
		}		
	}
	//Funktio tietojen hakemista varten
	//GET   /asiakkaat/{hakusana}
	function haeTiedot(){	
		document.getElementById("tbody").innerHTML = "";
		fetch("asiakkaat/" + document.getElementById("hakusana").value,{//Lähetetään kutsu backendiin
		      method: 'GET'
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()	
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
			var asiakkaat = responseJson.asiakkaat;	
			var htmlStr="";
			for(var i=0;i<asiakkaat.length;i++){			
	        	htmlStr+="<tr>";
	        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
	        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
	        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
	        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";  
	        	htmlStr+="<td><a class='linkki' href='muutaasiakas.jsp?id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
	        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"','"+asiakkaat[i].etunimi+"','"+asiakkaat[i].sukunimi+"')>Poista</span></td>";
	        	htmlStr+="</tr>";        	
			}
			document.getElementById("tbody").innerHTML = htmlStr;		
		})	
	}

	//Funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja välitetään poistettavan tiedon id. 
	//DELETE /autot/id
	function poista(id,etunimi,sukunimi){
		if(confirm("Poista asiakas " + etunimi+" "+sukunimi +"?")){	
			fetch("asiakkaat/"+ id,{//Lähetetään kutsu backendiin
			      method: 'DELETE'		      	      
			    })
			.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
				return response.json()
			})
			.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
				var vastaus = responseJson.response;		
				if(vastaus==0){
					document.getElementById("ilmo").innerHTML= "Asiakkaan poisto epäonnistui.";
		        }else if(vastaus==1){	        	
		        	document.getElementById("ilmo").innerHTML="Asiakkaat" + etunimi+" "+sukunimi +" poisto onnistui.";
					haeTiedot();        	
				}	
				setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
			})		
		}	
	}		
	
	
	</script>
</body>
</html>