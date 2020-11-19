<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Asiakaslistaus</title>
<style>


table {
   border: 10px  solid #2e2e2e;
  background-color:lightskyblue;
    font-family: Arial, Helvetica, sans-serif;
    max-width: 550px;
    width: 100%;
    margin: 10px;
    height: auto;
  	}
  	
th{

padding-top: 5px;
text-align: left;
padding-left: 5px;

} 

td{
padding-left: 5px;
border-top: 2px solid darkgrey;

} 	

input{
font-family: Arial;
float: left;
display: inline-block;
background-color: darkgrey;

}

  	
 .hakuotsikko{
 text-align: "right";
 
 }
 


 }


</style>
</head>
<body>
<table id="listaus">
	<thead>	
		<tr >
			<th class="hakuotsikko" >Hakusana:</th>
			<th colspan="2"><input size="35" type="text" id="hakusana"></th>
			<th><input type="button"  value="HAKU" ></th>
		</tr>			
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sposti</th>							
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
<script>
$(document).ready(function(){
	
	haeAutot();
	$("#hakunappi").click(function(){		
		haeAutot();
	});
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeAutot();
		  }
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
});	

function haeAutot(){
	$("#listaus tbody").empty();
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){//Funktio palauttaa tiedot json-objektina		
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>";  
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });	
    }});
}

</script>
</body>
</html>