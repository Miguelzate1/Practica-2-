:- use_module(library(lists)).

vehiculo(toyota, yaris, sedan, 19500, 2022).
vehiculo(toyota, landcruiser, suv, 28500, 2023).
vehiculo(toyota, hilux, pickup, 37500, 2023).
vehiculo(toyota, celica, sport, 46500, 2022).
vehiculo(toyota, hyperion, supersport, 1180000, 2024).

vehiculo(ford, bronco, suv, 32500, 2023).
vehiculo(ford, taurus, sedan, 25500, 2022).
vehiculo(ford, ranger, pickup, 35500, 2023).
vehiculo(ford, shelby, sport, 48500, 2023).
vehiculo(ford, lightning, supersport, 990000, 2022).

vehiculo(bmw, ix3, suv, 61500, 2023).
vehiculo(bmw, serie5, sedan, 39500, 2022).
vehiculo(bmw, z4, sport, 73000, 2023).
vehiculo(bmw, i8, supersport, 1275000, 2024).
vehiculo(bmw, x6, suv, 67000, 2024).


vehicle(Marca, Ref, Tipo, Precio, Anio) :- vehiculo(Marca, Ref, Tipo, Precio, Anio).

imprimir_vehiculos([H|T]) :-
    H = vehiculo(M,Mo,Ti,P,A),
    format('Marca: ~w | Modelo: ~w | Tipo: ~w | Precio: ~d | Anno: ~d~n', [M,Mo,Ti,P,A]),
    (T == [] -> true ; imprimir_vehiculos(T)).
imprimir_vehiculos([]).

datos :-
    write('Ingrese marca (toyota/ford/bmw): '), read(Marca),
    write('Ingrese tipo (suv/sedan/pickup/sport/supersport): '), read(Tipo),
    write('Ingrese presupuesto maximo: '), read(Presupuesto),
    (   findall(vehiculo(Marca,Modelo,Tipo,Precio,Ano),
        (vehiculo(Marca,Modelo,Tipo,Precio,Ano), Precio =< Presupuesto),
        Resultado),
        Resultado \= [] ->
            imprimir_vehiculos(Resultado)
    ;   write('No se encontraron vehiculos con esos criterios'), nl
    ).

filtrar_vehiculos(Marca, Tipo, Presupuesto, Resultado) :-
    findall(vehiculo(Marca, Modelo, Tipo, Precio, Ano),
        (vehiculo(Marca, Modelo, Tipo, Precio, Ano), Precio =< Presupuesto),
        Resultado).

filtrar_por_categoria :-
    write('Categoria: '), read(Categoria),
    write('Precio max: '), read(PrecioMax),
    findall(vehiculo(M,Mo,C,P,A), (vehiculo(M,Mo,C,P,A), C == Categoria, P =< PrecioMax), R),
    imprimir_vehiculos(R).

referencias_por_marca(Marca, L) :-
    findall(Mo, vehiculo(Marca,Mo,_,_,_), L).

sedan_prices(Prices) :-
    findall(Precio, (vehiculo(_, _, sedan, Precio, _), Precio =< 500000), Prices).

total_sedan_value_under_limit(Total) :-
    sedan_prices(Prices),
    sum_list(Prices, Total),
    Total =< 500000.

meet_budget(Reference, BudgetMax):-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.

vehicles_by_brand(Brand, Refs) :-
    findall(Ref, vehicle(Brand, Ref, _, _, _), Refs).

vehicles_grouped_by_brand(Brand, Grouped):-
    bagof((Type, Refs),
          bagof(Ref, Price^Year^(vehicle(Brand, Ref, Type, Price, Year)), Refs),
          Grouped).

sum_prices([], 0).
sum_prices([(_, Price)|T], Total) :-
    sum_prices(T, Rest),
    Total is Price + Rest.

generate_report(Brand, Type, Budget, Result) :-
    findall((Ref, Price),
            (vehicle(Brand, Ref, Type, Price, _), Price =< Budget),
            Vehicles),
    sum_prices(Vehicles, Total),
    Total =< 1000000,
    Result = Vehicles.

test_case1(Refs) :-
    findall(Ref, (vehicle(toyota, Ref, suv, Price, _), Price < 30000), Refs).

test_case2(Grouped) :-
    bagof((Type, Year, Ref), vehicle(ford, Ref, Type, _, Year), Grouped).

test_case3(Vehicles, Total) :-
    findall((Ref, Price), (vehicle(_, Ref, sedan, Price, _), Price =< 500000), Vehicles),
    sum_prices(Vehicles, Total),
    Total =< 500000.


%% caso 1: findall(vehiculo(toyota,Mo,suv,P,_), (vehiculo(toyota,Mo,suv,P,_), P < 30000), R).
% caso 2: bagof(vehiculo(ford,Mo,C,P,A), vehiculo(ford,Mo,C,P,A), R).
% total_sedan_value_under_limit(Total).