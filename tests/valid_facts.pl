% --- Generation 1 ---
parent(diana, ethan).
parent(diana, fiona).
parent(edward, ethan).
parent(edward, fiona).

female(diana).
male(edward).
married(diana, edward).

% --- Generation 2 ---
parent(ethan, gabriel).
parent(ethan, hannah).
parent(claire, gabriel).
parent(claire, hannah).

parent(fiona, ian).
parent(fiona, julia2).
parent(henry, ian).
parent(henry, julia2).

male(ethan). female(fiona). female(claire). male(henry).
married(ethan, claire). married(fiona, henry).

% --- Generation 3 ---
parent(gabriel, karl).
parent(gabriel, laura).
parent(amelia, karl).
parent(amelia, laura).

parent(hannah, max).
parent(hannah, nina).
parent(oliver, max).
parent(oliver, nina).

parent(ian, oscar).
parent(ian, paula).
parent(sophia2, oscar).
parent(sophia2, paula).

parent(julia2, quinn).
parent(julia2, rachel).
parent(james2, quinn).
parent(james2, rachel).

male(gabriel). female(hannah). female(amelia). male(oliver).
male(ian). female(sophia2). female(julia2). male(james2).

married(gabriel, amelia). married(hannah, oliver).
married(ian, sophia2). married(julia2, james2).

% --- Generation 4 ---
male(karl). female(laura). male(max). female(nina).
male(oscar). female(paula). male(quinn). female(rachel).

% --- Generation 5 ---
parent(karl, samuel). parent(karl, tina). parent(emma3, samuel). parent(emma3, tina).
parent(laura, victor). parent(laura, wendy). parent(liam2, victor). parent(liam2, wendy).
parent(max, xavier). parent(max, yvonne). parent(maya, xavier). parent(maya, yvonne).
parent(oscar, zach). parent(oscar, alice2). parent(noah3, zach). parent(noah3, alice2).
parent(quinn, ben). parent(quinn, carla). parent(luke2, ben). parent(luke2, carla).

male(samuel). female(tina). male(victor). female(wendy). male(xavier). female(yvonne).
male(zach). female(alice2). male(ben). female(carla).
female(emma3). male(liam2). female(maya). male(noah3). male(luke2).

married(karl, emma3). married(laura, liam2). married(max, maya). married(oscar, noah3). married(quinn, luke2).

% --- Generation 6 ---
parent(samuel, daniel). parent(tina2, daniel).    % tina2 instead of tina
parent(victor, evelyn). parent(wendy2, evelyn).   % wendy2 instead of wendy
parent(xavier, felix). parent(yvonne2, felix).     % yvonne2 instead of yvonne
parent(zach, grace2). parent(alice3, grace2).      % alice3 instead of alice2
parent(ben, hannah2). parent(carla2, hannah2).     % carla2 instead of carla

male(daniel). female(tina2). female(evelyn). female(wendy2).
male(felix). female(yvonne2). female(grace2). female(alice3).
male(hannah2). female(carla2).

married(samuel, tina2). married(victor, wendy2). married(xavier, yvonne2). married(zach, alice3). married(ben, carla2).
