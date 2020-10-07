-- import Data.Set
import qualified Data.Set as Set
import qualified Data.List as List
data Foo = Foo_num {left::[Foo],right::[Foo]}
        -- deriving (Show) -- 不要继承默认的输出格式

instance Num Foo where

    (+) x y = Foo_num {
        left=Set.toList(Set.union (Set.fromList(List.map ((+)y) (left x))) (Set.fromList(List.map ((+)x) (left y))) ),
        right=Set.toList(Set.union (Set.fromList(List.map ((+)y) (right x))) (Set.fromList(List.map ((+)x) (right y))) )
    }

    
instance Eq Foo where
    x == y = (x <= y) && (y <= x)

instance Ord Foo where
    -- 比较大小
    -- 由于这里我的取出最大值和最小值的函数只能对List操作(不会写对Set操作的555)，就只好转换成List了
    x <= y = (maxelem(left x) <= y) && (x <= minelem(right y))

-- Bonus
instance Show Foo where
    -- 开始时直接尝试用如下(被注释部分)的方法输出，发现还是会带有括号并带有元素，这并不符合题意
    -- show (Foo_num a b) ="{" ++ show a ++  "|" ++ show b ++ "}"  
    -- 仔细读题后感觉题目是想用递归定义，这很合理

    show (Foo_num [] []) = "{|}"
    show (Foo_num (x1:xs1) []) = "{" ++ show_FooList (x1:xs1) ++ "|" ++ "}"
    show (Foo_num [] (x2:xs2)) = "{" ++ "|" ++ show_FooList (x2:xs2) ++ "}"
    show (Foo_num (x1:[]) (x2:[])) = "{" ++ show x1 ++ "|"++ show x2 ++ "}"
    show (Foo_num (x1:[]) (x2:xs2)) = "{" ++ show x1 ++ "|" ++ show_FooList(x2:xs2) ++ "}"
    show (Foo_num (x1:xs1) (x2:[])) = "{" ++ show_FooList (x1:xs1) ++ "|" ++ show x2 ++ "}"
    show (Foo_num (x1:xs1) (x2:xs2)) = "{" ++ show_FooList (x1:xs1) ++ "|" ++ show_FooList (x2:xs2) ++ "}"



-- 一直不知道如何在递归里嵌套一个递归以实现(x1:xs1)中xs1的输出
-- 但这是函数式编程啊，直接写一个用来打印[Foo]类型的数据不就简单多了！妙不可言！
-- 于是便有了show_FooList函数
show_FooList [] = ""
show_FooList (x:[]) = show x
show_FooList (x:xs) = show x ++ show_FooList xs


-- 定义一个zero以便调用
zero = Foo_num [] []

-- 求最大元素
maxelem (x:xs) = if length xs > 0
    -- then max x (maxelem xs)
    then if x <= (maxelem xs)
        then (maxelem xs)
        else x
    else x

-- 求最小元素
minelem (x:xs) = if length xs > 0
    -- then min x (minelem xs)
    then if x <= (minelem xs)
        then x
        else (minelem xs)
    else x