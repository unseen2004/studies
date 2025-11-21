# Plik: z2.jl
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 2 z listy nr 1 (Obliczenia Naukowe).
#       Sprawdzenie stwierdzenia Kahana dotyczącego obliczania
#       epsilona maszynowego przez wzór 3(4/3 - 1) - 1.

"""
    check_kahan_macheps(T::Type{<:AbstractFloat})

Oblicza wyrażenie Kahana \$3(4/3 - 1) - 1\$ w arytmetyce typu T,
krok po kroku, aby zachować błędy zaokrągleń właściwe dla typu T.

Zwraca krotkę: (wynik_obliczenia, oczekiwany_macheps)
"""
function check_kahan_macheps(T::Type{<:AbstractFloat})
    # Definiujemy stałe w arytmetyce podanego typu T
    # Konwersja zapewnia, że wszystkie operacje będą wykonane 
    # w docelowej precyzji.
    three = T(3.0)
    four = T(4.0)
    one = T(1.0)
    
    # Wykonujemy obliczenia krok po kroku, zgodnie z kolejnością 
    # działań w arytmetyce fl()
    
    # Krok 1: fl(4/3)
    val_4_3 = four / three
    
    # Krok 2: fl(fl(4/3) - 1)
    val_minus_1 = val_4_3 - one
    
    # Krok 3: fl(3 * fl(fl(4/3) - 1))
    val_times_3 = three * val_minus_1
    
    # Krok 4: fl(fl(3 * fl(fl(4/3) - 1)) - 1)
    kahan_result = val_times_3 - one
    
    # Wartość referencyjna
    macheps = eps(T)
    
    return kahan_result, macheps
end

"""
    run_kahan_test()

Uruchamia test Kahana dla typów Float16, Float32, Float64
i drukuje wyniki w formie tabeli porównawczej.
"""
function run_kahan_test()
    println("--- ZADANIE 2: Stwierdzenie Kahana ---")
    println("\nEksperymentalne sprawdzenie wzoru: 3(4/3 - 1) - 1")
    println("---------------------------------------------------------------------")
    println("| Typ     | Wynik wzoru Kahana      | Oczekiwany macheps (eps(T)) | Zgodność |")
    println("|---------|-------------------------|-----------------------------|----------|")
    
    # Test dla Float16
    k16, e16 = check_kahan_macheps(Float16)
    println("| Float16 | $(k16)            | $(e16)             | $(k16 == e16)  |")
    
    # Test dla Float32
    k32, e32 = check_kahan_macheps(Float32)
    println("| Float32 | $(k32)        | $(e32)         | $(k32 == e32) |")

    # Test dla Float64
    k64, e64 = check_kahan_macheps(Float64)
    println("| Float64 | $(k64) | $(e64) | $(k64 == e64) |")
    println("---------------------------------------------------------------------")
end

# Uruchomienie testu
run_kahan_test()
