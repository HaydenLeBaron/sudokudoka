"""
Functional Sudoku
"""

import sys
import random as rand

from copy import copy

def print_board(board, dim):
        if board is None:
                print(None)
                return

        # Convert to 2d list
        mtrx = [board[i:i+dim] for i in range(0, len(board), dim)]
        for row in mtrx:
                print(row)

def remove_zeros(board):
        """
        *No external side effects*
        """
        return [elem for elem in board if elem != 0]

def is_valid(board, dim):
        """
        *No external side-effects

        Returns True if board is valid, false otherwise.
        """

        row_to_numlist = {}
        col_to_numlist = {}

        for idx in range(len(board)):
                if idx // dim not in row_to_numlist.keys():
                        row_to_numlist[idx // dim] = []

                if idx % dim not in col_to_numlist.keys():
                        col_to_numlist[idx % dim] = []

                row_to_numlist[idx // dim].append(board[idx])
                col_to_numlist[idx % dim].append(board[idx])

        for key in row_to_numlist.keys():
                if len(remove_zeros(copy(row_to_numlist[key]))) != len(set(remove_zeros(copy(row_to_numlist[key])))):
                                        return False

        for key in col_to_numlist.keys():
                if len(remove_zeros(copy(col_to_numlist[key]))) != len(set(remove_zeros(copy(col_to_numlist[key])))):
                                        return False   

        # Check for no repeated values in grids
        # TODO: implement

        return True

def get_blank_cells_idx_list(board):
        """
        *No external side-effects*
        Return a list containing the indices of all
        blank board cells.
        """
        ret = []
        for i in range(len(board)):
                if board[i] == 0:
                        ret.append(i)
        return ret


def find_next_valid_board(board, idx, dim):
        """
        *No external side-effects

        # There needs to be a random aspect to this or the solver will get stuck in an infinite recursive loop
        """

        #if idx >= len(board): # Don't go out of bounds
                #return None

        new_board = copy(board)

        # Can get stuck in an infinite recursive loop
        #for candidate in range(1,dim+1):
        #       new_board[idx] = candidate
        #       if is_valid(new_board, dim):
        #               return new_board

        upper = dim
        candidates = [x for x in range(1, dim+1)]
        rand.seed()
        while len(candidates) != 0:
                i = rand.randrange(0, upper)
                new_board[idx] = candidates[i]
                if is_valid(new_board, dim):
                        print("CHOSEN CANDIDATE: ", candidates[i], "to go in idx", idx) # DBG
                        return new_board
                else:
                        # Remove candidate
                        candidates = [x for x in candidates if x != candidates[i]]
                        upper -= 1


        return None # No next valid board in existence


def cons(list1, elem):
        """
        Racket `cons`
        """
        return list1 + [elem]

def last(list):
        """
        Racket `last`
        """
        return copy(list[len(list)-1])


def penult(list):
        return copy(list[len(list)-2])

def all_but_last(list):
        return copy(list[0:len(list)-1])

def is_filled(board):
        if board == None:
                return False

        for elem in board:
                if elem == 0:
                        return False
        return True

"""
def solve(board, dim, visited_boards, idx0_list, idx):
        NXT_BOARD = find_next_valid_board(board, idx0_list[idx], dim) # let

        if NXT_BOARD is not None:
                if is_filled(NXT_BOARD) and is_valid(NXT_BOARD, dim):
                        print("EXIT")
                        sys.exit(NXT_BOARD) # Success!
                else:
                        return solve(NXT_BOARD,
                                dim,
                                cons(visited_boards, board),
                                idx0_list, idx+1)
        else: # No valid next board => backtrack
                return solve(find_next_valid_board(last(visited_boards), idx0_list[idx-1], dim),
                        dim,
                        all_but_last(visited_boards),
                        idx0_list, idx-2)
"""

# NOTE: idx0_list is along for the ride

def solve(board, dim, visited_boards, idx0_list, idx):

        #print("VISITED: ", visited_boards)
        print("CURR BOARD: ")
        print_board(board, dim) # DBG

        if idx != 0:
                print("LAST VISITED BOARD:", last(visited_boards))
                print("idx0[idx]", idx0_list[idx])

        if (board != None): # Regular case
                print("A") # DBG
                if (is_filled(board) and is_valid(board, dim)):
                        print("EXIT")
                        sys.exit(board) # SUCCESS!
                else:
                        print("B") # DBG
                        return solve(find_next_valid_board(board, idx0_list[idx], dim), dim,
                                cons(visited_boards, board), idx0_list, idx+1)
        else :  # No valid board this time => Backtrack
                print("C") # DBG
                return solve(last(visited_boards), dim,
                        all_but_last(visited_boards), idx0_list, idx) # FIXME: when I do just idx, it mostly solves it but leaves 0s whenever it takes the Backtrack branch

                #return solve(last(visited_boards), dim,
                        #visited_boards, idx0_list, idx)


# TODO: test a board in which backtracking matters. The else branch was never hit maybe




def solve_driver(board, dim):

        # TODO: calculate dim given board in a function
        try:
                solve(board, dim, [],
                        get_blank_cells_idx_list(board), 0)
        except SystemExit as e:
                print("YAY: RET == ", e.args[0])
                return e.args[0]



# =====================================================








valid_full_board1 = [1, 2, 3,
                                                                                 3, 1, 2,
                                                                                 2, 3, 1]

valid_part_board1 = [1, 2, 0,
                                                                                 0, 1, 2,
                                                                                 2, 0, 1]

invalid_full_board1 = [1, 3, 3,
                                                                                   3, 1, 2,
                                                                                   2, 3, 1]

invalid_part_board1 = [1, 2, 0,
                                                                                   0, 2, 0,
                                                                                   2, 0, 1]

invalid_part_board2 = [2, 1, 0,
                                                                                   0, 3, 2,
                                                                                   1, 0, 1]

sudoku1 = [1, 0, 0,
                                         0, 1, 2,
                                         2, 0, 0]


wikipedia_sudoku_unsolved = [5, 3, 0, 0, 7, 0, 0, 0, 0, 6, 0, 0, 1, 9, 5, 0, 0, 0, 0, 9, 8, 0, 0, 0, 0, 6, 0, 8, 0, 0, 0, 6, 0, 0, 0, 3, 4, 0, 0, 8, 0, 3, 0, 0, 1, 7, 0, 0, 0, 2, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 2, 8, 0, 0, 0, 0, 4, 1, 0, 0, 0, 5, 0, 0, 0, 0, 8, 0, 0, 7, 9]





import unittest
class TestStringMethods(unittest.TestCase):

    def test_is_valid(self):
                self.assertTrue(is_valid(valid_full_board1, 3))
                self.assertTrue(is_valid(valid_part_board1, 3))
                self.assertFalse(is_valid(invalid_full_board1, 3))
                self.assertFalse(is_valid(invalid_part_board1, 3))             
                self.assertFalse(is_valid(invalid_part_board2, 3))

    def test_find_next_valid_board(self):
        print("Next board:\n", find_next_valid_board(valid_part_board1, 2, 3))
        next_valid_board1 = find_next_valid_board(valid_part_board1, 2, 3)
        self.assertNotEqual(valid_part_board1, next_valid_board1)
        self.assertTrue(is_valid(next_valid_board1, 3))
        self.assertEqual(next_valid_board1[2], 3)

    def test_solve1(self):
        print("TEST SOLVE 1 ================================")
        dim = 3
        soln = solve_driver(sudoku1, dim)
        print_board(soln, dim)
        self.assertTrue(is_valid(soln, dim))
        self.assertEqual(soln, remove_zeros(soln))  # Make sure there are no blank spaces

    def test_solve_wikipedia(self):
        print("TEST SOLVE WIKIPEDIA =========================")
        dim = 9
        soln = solve_driver(wikipedia_sudoku_unsolved, dim)
        print_board(soln, dim)
        self.assertTrue(is_valid(soln, dim))
        self.assertEqual(soln, remove_zeros(soln))  # Make sure there are no blank spaces









if __name__ == '__main__':
    unittest.main()


print("------------")   
solve("hello", 9)
