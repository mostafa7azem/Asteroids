module Main(main, initialState, update, handleKeys, render) where
import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import Shapes
import DataTypes
import MainMenu
import Pause
import GameOver
import General
import SinglePlayer
import Player
import Cooperative
import Asteroids
import System.Random
--functions in this file is responsible for finding the appropriate function according to mode
-- see 'update' function as example 
window :: Display
window = InWindow "Asteroids" (width, height) (offset, offset)

background :: Color
background = black

fps :: Int
fps = 60

-- | main function holdes the gloss required functions
main :: IO ()
main = play window background fps initialState render handleKeys update

------------------- Basic Functions --

-- | initialize the states of the game
initialState :: AsteroidsGame -- ^ initialized game
initialState    = Game
   { players    = []  
    , gameMode  = Menu
    , whereFrom = Menu
    , gWidth    = (fromIntegral width)
    , gHeight   = (fromIntegral height)
    , asteroids = initializeAsteroids 2
   }


-- | update the game according to the Game Mode.
update :: Float -- ^ game speed 
 -> AsteroidsGame -- ^ current game state
 -> AsteroidsGame -- ^ updated game stare             
update seconds game | (gameMode game) == Menu = updateMenu seconds game initialState
                    | (gameMode game) == Pause = updatePause seconds game
                    | (gameMode game) == GameOver = updateGameOver seconds game
                    | otherwise = General.updateGeneralGame game



--EventKey Key KeyState Modifiers (Float, Float) 
--ref:: https://hackage.haskell.org/package/gloss-1.11.1.1/docs/Graphics-Gloss-Interface-IO-Game.html
-- | Handle the key events according to the Game Mode.
handleKeys :: Event -- ^ gloss event 
 -> AsteroidsGame   -- ^ current game state
 -> AsteroidsGame   -- ^ updated game state
handleKeys event game
                       | mode == Menu = handleMenuKeys event game          --same as the update function here u call the appropriate key events 
                       | mode == Pause = handlePauseKeys event game
                       | mode == GameOver = handleGameOverKeys event game
                       | otherwise = handleGeneralKeys event game
                  where mode = gameMode game

-- | Render the game according to the Game Mode.
render :: AsteroidsGame  --- update the render like the update function in order to behave like the update function
       -> Picture   --TODO BELBEL splite render function to different files for better organization
render game 
 | (gameMode game) == Menu = menuRender game
 | (gameMode game) == Pause = pauseRender game
 | (gameMode game) == GameOver = gameOverRender game
 | otherwise = generalRender game
