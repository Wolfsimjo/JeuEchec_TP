package edu.uqac.aop.aspect;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;
import edu.uqac.aop.chess.piece.Piece;

public aspect Aspect_Piece {
	pointcut piece(Move mv, Player p, Piece pi): call(boolean *.isMoveLegal(Move))&&args(mv)&&this(p)&&target(pi);

	boolean around(Move mv, Player p, Piece pi) : piece(mv,p,pi) 
	{

		Board board = p.getBoard();
		// Spot initial = board.getGrid()[mv.xI][mv.yI];
		Spot[][] grid = board.getGrid();
		board.print();
		Spot end = grid[mv.xF][mv.yF];
		
		if (!end.isOccupied()) {
			return true;
		}
		if (end.getPiece().getPlayer() == p.getColor()) { // Case finale
															// contient une
															// piece alliée
			return false;
		}

		return true;
	}
}
