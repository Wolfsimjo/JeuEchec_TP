package edu.uqac.aop.chess.aspect;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.util.Date;

import edu.uqac.aop.chess.agent.*;
import edu.uqac.aop.chess.*;

public aspect Log {
	pointcut log(Player p): call(Move Player.makeMove())&&target(p);
	
	after(Player p) returning( Move mv) : log(p) 
	{
		Date aujourdhui = new Date();
		DateFormat mediumDateFormat = DateFormat.getDateTimeInstance(
		DateFormat.MEDIUM,
		DateFormat.MEDIUM);
		
		String dateExec;
		dateExec = mediumDateFormat.format(aujourdhui);
		System.out.println(dateExec);
		
		String player="";
		if(p instanceof HumanPlayer)
			player = "L'humain joue";
		else if(p instanceof AiPlayer)
			player = "L'IA joue";
		System.out.println(player);
		
		String mouvement;
		mouvement = "La piece se deplace de la case "+ (char)(mv.xI+97)+(mv.yI+1)+" vers la case "+
				(char)(mv.xF+97)+(mv.yF+1);
		System.out.println(mouvement);

		File f = new File ("Log_mouvement");
		try{
		    PrintWriter pw = new PrintWriter (new BufferedWriter (new FileWriter (f,true)));
		    pw.print(dateExec+" ");
		    pw.print(player+" ");
		    pw.println (mouvement);
		    pw.close();
		}
		catch (IOException exception){
		    System.out.println ("Erreur lors de la lecture : " + exception.getMessage());
		}
	}
	
	pointcut first_game_log(): call(* Chess.play());
	
	before () : first_game_log(){
		Date aujourdhui = new Date();
		DateFormat mediumDateFormat = DateFormat.getDateTimeInstance(
		DateFormat.MEDIUM,
		DateFormat.MEDIUM);
		
		String dateExec;
		dateExec = mediumDateFormat.format(aujourdhui);		
		
		File f = new File ("Log_mouvement");
		try{
		    PrintWriter pw = new PrintWriter (new BufferedWriter (new FileWriter (f,true)));
		    pw.print("=====================");
		    pw.println ();
		    pw.print("Debut de la partie le ");
		    pw.print(dateExec +" ");
		    pw.println ();
		    pw.close();
		}
		catch (IOException exception){
		    System.out.println ("Erreur lors de la lecture : " + exception.getMessage());
		}
	}
}