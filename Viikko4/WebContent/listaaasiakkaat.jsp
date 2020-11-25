<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
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

#uusiAsiakas {
	cursor: pointer;
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

.poista, .muokkaa{
cursor: pointer;
font-weight: bold;
color: black;
text-decoration:none;
font-family: Arial, Helvetica, sans-serif;
}

.right {
	text-align: right;
}
}
</style>
</head>
<body>
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="7" class="right"><span id="uusiAsiakas">
						Lisää uusi asiakas</span></th>
			</tr>
			<tr>


				<th colspan="2" class="right">Hakusana:</th>
				<th colspan="3"><input size="40" type="text" id="hakusana"></th>
				<th><input type="button" value="HAKU" id="hakunappi"></th>
			</tr>
			<tr>
				<th>ID</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th> </th>
				<th> </th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<script>
		$(document).ready(function() {

			$("#uusiAsiakas").click(function() {
				document.location = "lisaaasiakas.jsp";
			});

			haeAsiakkaat();
			$("#hakunappi").click(function() {
				haeAsiakkaat();
			});
			$(document.body).on("keydown", function(event) {
				if (event.which == 13) { //Enteriä painettu, ajetaan haku
					haeAsiakkaat();
				}
			});
			$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
		});

	
		
		
		function haeAsiakkaat() {
			$("#listaus tbody").empty();
			$.ajax({
				url : "asiakkaat/" + $("#hakusana").val(),
				type : "GET",
				dataType : "json",
				success : function(result) {//Funktio palauttaa tiedot json-objektina		
					$.each(result.asiakkaat, function(i, field) {
						var htmlStr;
						htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
						htmlStr += "<td>" + field.asiakas_id + "</td>";
						htmlStr += "<td>" + field.etunimi + "</td>"; 
						htmlStr += "<td>" + field.sukunimi + "</td>";
						htmlStr += "<td>" + field.puhelin + "</td>";
						htmlStr += "<td>" + field.sposti + "</td>";							
						htmlStr+="<td><a class='muokkaa' href='muutaasiakas.jsp?id="+field.asiakas_id+"'>Muuta</span></td>";
						htmlStr+="<td><span class='poista' onclick=poista('"+field.asiakas_id+"','"+field.etunimi+"','"+field.sukunimi+"')>Poista</span></td>";
						htmlStr += "</tr>";
						$("#listaus tbody").append(htmlStr);
					});
				}
			});
		}
		function poista(asiakas_id,etunimi,sukunimi){
			if(confirm("Poista asiakas "+etunimi+" "+sukunimi+"?")){
				$.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
			        if(result.response==0){
			        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
			        }else if(result.response==1){
			        	$("#rivi_"+asiakas_id).css("background-color", "red"); //Värjätään poistetun asiakkaan rivi
			        	alert("Asiakkaan " + etunimi+" "+sukunimi +" poisto onnistui.");
						haeAsiakkaat();        	
					}
			    }});
			}
		}
	</script>
</body>
</html>