module PutJson where

import Data.List (intercalate)
import Json

renderJValue (JString s)   = show s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"

renderJValue (JObject o) = "{"++pairs o++"}"
    where pairs [] = ""
          pairs ps = intercalate ", " (map renderPair ps)
          renderPair (k,v) = show k++": "++renderJValue v

renderJValue (JArray a) = "["++values a++"]"
    where values [] = ""
          values vs = intercalare ", " (map renderJValue vs)

putJValue :: JValue -> IO ()
putJValue v = putStrLn$renderJValue v
