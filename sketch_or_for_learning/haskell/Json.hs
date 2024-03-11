module Json (JValue(..),getStr,getBool,getInt,getDouble,getObj,getArray,isNull) where

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String,JValue)]
            | JArray [JValue]
              deriving (Eq,Ord,Show)

getStr (JString s) = Just s
getStr _           = Nothing

getInt (JNumber n) = Just $ truncate n
getInt _           = Nothing

getDouble (JNumber n) = Just n
getDouble _           = Nothing

getBool (JBool b) = Just b
getBool _         = Nothing

getObj (JObject o) = Just o
getObj _           = Nothing

getArray (JArray a) = Just a
getArray _          = Nothing

isNull v = v==JNull
