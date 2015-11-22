package edu.uqac.aop.chess.piece;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

public class Bishop extends Piece {

	public Bishop(int player) {
		super(player);
	}

	public Bishop() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return ((this.player == Player.WHITE) ? "P" : "p");
	}

	@Override
	public boolean isMoveLegal(Move mv) {
		// TODO Implement this with an aspect
		return false;}
}
