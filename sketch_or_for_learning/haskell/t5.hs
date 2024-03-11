data T1 = Node Int T1 T1 | L Int
data T a = N a (T a) (T a) | L a

sm (L _) = 1
sm (N _ l r) = (sm l)+(sm r)

smv (L x) = x
smv (N x l r) = x+(smv l)+(smv r)
