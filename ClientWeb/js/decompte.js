		// Fonction qui sera appeler à la sortie du Timeout
		function affichage() {
		// Affichage du message dans la div affichage
		    document.getElementById("affichage").innerHTML = "Fin du compte &agrave; rebour";
		};

		// Initialisation de la temporisation
		
		temp = 0;
		
		jQuery(function(){
		// Boucle de décrémentation
		// 10 représente le temps en secondes
		    for (i = 10; i > -1; i--) {
		    	if (i > 60) {
			        setTimeout("jQuery('#affichage').text('Restant " + i/60 + " minute(s) " + i + " seconde(s)');", temp);
		    	}
			    else if (i > 3600) {
			    	setTimeout("jQuery('#affichage').text('Restant " + (i/60)/60  + " heure(s) " + i/60 + " minute(s) " + i + "seconde(s));", temp);
			    }
			    else if (i > 86400) {
			    	setTimeout("jQuery('#affichage').text('Restant " + (i/60)/60/24 + " Jour(s) " + + (i/60)/60  + " heure(s) " + i/60 + " minute(s) " + i + "seconde(s));", temp);
			    }
			    else {
			        setTimeout("jQuery('#affichage').text('Restant "+i+" secondes');",temp);
			    }
		        temp += 1000;
		    }
		});
		 
		jQuery(document).ready(function(){
		    setTimeout("affichage();",temp - 1000);
		});