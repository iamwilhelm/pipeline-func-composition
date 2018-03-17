import Html exposing (text)
import Array exposing (Array)
import Task exposing (..)
import Http
import Dict exposing (Dict)

type Data = Datum (List Int)
type alias Model = List Float

csv : String -> Task x Data
csv filename =
  succeed <| Datum [1,2,3]

trainer : Data -> Task x Model
trainer data =
  succeed <| [1.1, 1.2, 1.3]

inference : Model -> Data -> Task x (List Bool)
inference model data =
  succeed <| [True, False, True]

-- |> map trainer
-- is same as
-- |> andThen (succeed << trainer)
irisPipeline : Task x (List Bool)
irisPipeline =
  csv "training.csv"
  |> andThen trainer
  |> andThen2 inference (csv "attrs.csv")

 
-----

csvUrl : String -> Task x (List String)
csvUrl filename =
  succeed ["google.com", "facebook.com", "amazon.com"]

fetchAll : List String -> Task Http.Error (List String)
fetchAll urls =
  sequence <| List.map (Http.toTask << Http.getString) urls

wordCount : List String -> Task x (List (Dict String Int))
wordCount pages =
  succeed [Dict.singleton "hello" 1]

wordCountMerge : List (Dict String Int) -> Task x (Dict String Int)
wordCountMerge counts =
  succeed <| Dict.singleton "world" 1

wc_pipeline : Task Http.Error (Dict String Int)
wc_pipeline =
  csvUrl "urls.csv"
  |> andThen fetchAll 
  |> andThen wordCount
  |> andThen wordCountMerge

main =
  text "hello world"

-------

andThen2 : (a -> b -> Task x c) -> Task x b -> Task x a -> Task x c
andThen2 func taskB taskA =
  andThen (\a -> andThen (func a) taskB) taskA

andThen3 : (a -> b -> c -> Task x d) -> Task x c -> Task x b -> Task x a -> Task x d
andThen3 func taskC taskB taskA =
  andThen (\a ->
    andThen (\b ->
      andThen (func a b) taskC
    ) taskB
  ) taskA
 