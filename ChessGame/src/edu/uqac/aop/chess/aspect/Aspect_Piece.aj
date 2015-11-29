package edu.uqac.aop.chess.aspect;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;
import edu.uqac.aop.chess.piece.*;

public aspect Aspect_Piece {
	pointcut piece(Move mv, Player p, Piece pi): call(boolean *.isMoveLegal(Move))&&args(mv)&&this(p)&&target(pi);

	boolean around(Move mv, Player p, Piece pi) : piece(mv,p,pi) 
	{
		Board board = p.getBoard();
		// Spot initial = board.getGrid()[mv.xI][mv.yI];
		Spot[][] grid = board.getGrid();
		Spot end = grid[mv.xF][mv.yF];
		int dirX = mv.xF - mv.xI, dirY = mv.yF - mv.yI;

		if (mv.xI == mv.xF && mv.yI == mv.yF) {
			return false;
		}

		if (pi instanceof Pawn) { // pion
			int dir = -1 * (int) Math.pow(-1, p.getColor());
			// on recupere la direction du pion
			if (mv.xI != mv.xF) {
				// si on se deplace sur le cote
				if (mv.xI != mv.xF + 1 && mv.xI != mv.xF - 1) {
					// si le mouvement n'est pas sur une case adjacente
					return false;
				}
				if (mv.yI + dir != mv.yF) {
					// si le mouvement n'est pas qu'une case en diagonale
					return false;
				}
				if (!(end.isOccupied())) {
					// si la case en diagonale ne contient pas de piece
					return false;
				}
			} else {
				// si on se deplace en ligne droite
				if (mv.yI != Math.floorMod(dir, 7)) {
					// si le deplacement n'est pas le premier
					if (mv.yI + dir != mv.yF || end.isOccupied()) {
						// si le deplacement n'est pas la case en face
						return false;
					}
				} else { // si c'est le premier deplacement
					if ((mv.yI + dir != mv.yF) && (mv.yI + 2 * dir != mv.yF)) {
						// si le deplacement n'est pas de 1 ou 2 cases
						return false;
					}
					if (mv.yI + 2 * dir == mv.yF && (grid[mv.xF][mv.yI + dir].isOccupied() || end.isOccupied())) {
						// si le deplacement est de 2 cases et qu'il y a un
						// obstacle
						return false;
					}

					/*
					 * if (!(mv.yI + dir == mv.yF || (mv.yI + 2 * dir == mv.yF
					 * && !(grid[mv.xI][mv.yI + dir].isOccupied())))) { return
					 * false; }
					 */
				}
			}

		} else if (pi instanceof Knight) { // cavalier
			if (!((mv.xF == mv.xI + 1 || mv.xF == mv.xI - 1) && (mv.yF == mv.yI + 2 || mv.yF == mv.yI - 2)
					|| (mv.yF == mv.yI + 1 || mv.yF == mv.yI - 1) && (mv.xF == mv.xI + 2 || mv.xF == mv.xI - 2))) {
				return false;
			}
		} else if (pi instanceof Rook) { // tour
			if (!((mv.xI == mv.xF) || (mv.yI == mv.yF))) {
				return false;
			} else {
				return !isPathOccuped(mv, dirX, dirY, grid, p);
			}

		} else if (pi instanceof Bishop) { // fou
			if (!(Math.abs(dirX) == Math.abs(dirY))) { // deplacement en
														// diagonale
				return false;
			} else {
				return !isPathOccuped(mv, dirX, dirY, grid, p);
			}
		} else if (pi instanceof Queen) { // reine
			if (!((Math.abs(dirX) == Math.abs(dirY)) || (mv.xI == mv.xF) || (mv.yI == mv.yF))) { // deplacement
																									// en
																									// diagonale
				return false;
			} else {
				return !isPathOccuped(mv, dirX, dirY, grid, p);
			}

		} else { // roi
			if (!((mv.xI == mv.xF || mv.xF == mv.xI + 1 || mv.xF == mv.xI - 1)
					&& (mv.yF == mv.yI - 1 || mv.yF == mv.yI + 1) || (mv.yF == mv.yI && (mv.xF == mv.xI + 1 || mv.xF == mv.xI - 1)))) {
				System.out.println(2);
				return false;
			}
		}

		if (end.isOccupied() && end.getPiece().getPlayer() == p.getColor()) {// Si
																				// la
																				// case
																				// finale
																				// est
																				// occupe
																				// par
																				// une
																				// piece
			return false; // allie
		}
		return true;
	}

	public boolean isPathOccuped(Move mv, int dirX, int dirY, Spot[][] grid, Player player) {
		int newX = mv.xI, newY = mv.yI;
		for (int iBcl = 1; iBcl <= Math.max(Math.abs(dirX), Math.abs(dirY)); iBcl++) {
			newX = mv.xI + (iBcl * (int) Math.signum(dirX));
			newY = mv.yI + (iBcl * (int) Math.signum(dirY));
			if (grid[newX][newY].isOccupied()) {
				if (newX == mv.xF && newY == mv.yF) {
					if (grid[newX][newY].getPiece().getPlayer() == player.getColor()) {
						return true;
					}
				} else {
					return true;
				}
			}
		}
		return false;
	}
}
