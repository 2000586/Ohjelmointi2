package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Myynti;
import model.dao.Dao;

/**
 * Servlet implementation class Asiakkaat
 */
@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Asiakkaat() {
		super();
		System.out.println("Asiakkaat.Asiakkaat()");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String pathInfo = request.getPathInfo();
		System.out.println("Path: " + pathInfo);
		String strJSON="";
		Dao dao = new Dao();
		ArrayList<Myynti> asiakkaat;
		if(pathInfo==null) {
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		
		}else if(pathInfo.indexOf("hae1")!=-1) {		//polussa on sana "haeyksi", eli haetaan yhden auton tiedot
			String id = pathInfo.replace("/hae1/", ""); //poistetaan polusta "/haeyksi/", jäljelle jää rekno		
			Myynti myynti = dao.etsiAsiakas(id);
			if(myynti==null) {
				strJSON = "{}";
			}else {
			JSONObject JSON = new JSONObject();
			JSON.put("asiakas_id", myynti.getAsiakas_id());
			JSON.put("etunimi", myynti.getEtunimi());
			JSON.put("sukunimi", myynti.getSukunimi());
			JSON.put("puhelin", myynti.getPuhelin());
			JSON.put("sposti", myynti.getSposti());	
			strJSON = JSON.toString();
			}
		}else{ //Haetaan hakusanan mukaiset autot
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		}	
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);		
	}



	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); // Muutetaan kutsun mukana tuleva json-string
																	// json-objektiksi
		Myynti myynti = new Myynti();
		myynti.setEtunimi(jsonObj.getString("etunimi"));
		myynti.setSukunimi(jsonObj.getString("sukunimi"));
		myynti.setPuhelin(jsonObj.getString("puhelin"));
		myynti.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if (dao.lisaaAsiakas(myynti)) { // metodi palauttaa true/false
			out.println("{\"response\":1}"); // Auton lisääminen onnistui {"response":1}
		} else {
			out.println("{\"response\":0}"); // Auton lisääminen epäonnistui {"response":0}
		}
	}

	/**
	 * @see HttpServlet#doPut(HttpServletRequest, HttpServletResponse)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		
		Myynti myynti = new Myynti();
		myynti.setAsiakas_id(Integer.parseInt(jsonObj.getString("asiakas_id")));
		myynti.setEtunimi(jsonObj.getString("etunimi"));
		myynti.setSukunimi(jsonObj.getString("sukunimi"));
		myynti.setPuhelin(jsonObj.getString("puhelin"));
		myynti.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaAsiakas(myynti)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  
		}else{
			out.println("{\"response\":0}");  
		}		
	}

		
		
	

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /ABC-222		
		System.out.println("polku: "+pathInfo);
		String poistettavaID = pathInfo.replace("/", "");		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaAsiakas(poistettavaID)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Auton poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Auton poistaminen epäonnistui {"response":0}
		}	

	}

}
