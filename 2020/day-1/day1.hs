import qualified Data.IntSet as S

main = do
      x <- lines <$> readFile "input"
      inp <- map (read::String->Int) x
      fmap (\l -> print l) inp
