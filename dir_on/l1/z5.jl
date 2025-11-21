# Plik: z5.jl
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 5 z listy nr 1 (Obliczenia Naukowe).
#       Badanie wpływu kolejności sumowania na błąd 
#       w obliczaniu iloczynu skalarnego.

"""
    sum_forward(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat

Oblicza iloczyn skalarny metodą (a) "w przód" [cite: 36-40].
Mnożenie x[i]*y[i] odbywa się wewnątrz pętli.
"""
function sum_forward(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    S = T(0.0)
    # Pętla zgodna z algorytmem (a) [cite: 38, 39]
    for i in 1:length(x)
        S = S + (x[i] * y[i])
    end
    return S
end

"""
    sum_backward(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat

Oblicza iloczyn skalarny metodą (b) "w tył" [cite: 41-45].
Mnożenie x[i]*y[i] odbywa się wewnątrz pętli.
"""
function sum_backward(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    S = T(0.0)
    # Pętla zgodna z algorytmem (b) [cite: 43, 44]
    for i in length(x):-1:1
        S = S + (x[i] * y[i])
    end
    return S
end

"""
    sum_sorted_desc(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat

Oblicza iloczyn skalarny metodą (c).
1. Oblicza wszystkie iloczyny p_i = x_i * y_i.
2. Sumuje dodatnie p_i (od największego do najmniejszego).
3. Sumuje ujemne p_i (od najmniejszego do największego).
4. Zwraca sumę wyników z pkt 2 i 3.
"""
function sum_sorted_desc(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    # Pre-obliczenie iloczynów, aby można je było posortować
    products = [x[i] * y[i] for i in 1:length(x)]
    
    pos_products = filter(p -> p > 0, products)
    neg_products = filter(p -> p < 0, products)
    
    # Sortowanie zgodne z instrukcją (c) 
    sort!(pos_products, rev=true) # Dodatnie: od największego
    sort!(neg_products)           # Ujemne: od najmniejszego (domyślnie)
    
    # Sumowanie częściowe
    sum_pos = T(0.0)
    for p in pos_products
        sum_pos += p
    end
    
    sum_neg = T(0.0)
    for p in neg_products
        sum_neg += p
    end
    
    # Zwrócenie sumy sum częściowych 
    return sum_pos + sum_neg
end

"""
    sum_sorted_asc(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat

Oblicza iloczyn skalarny metodą (d) "przeciwnie do (c)".
1. Oblicza wszystkie iloczyny p_i = x_i * y_i.
2. Sumuje dodatnie p_i (od najmniejszego do największego).
3. Sumuje ujemne p_i (od największego do największego).
4. Zwraca sumę wyników z pkt 2 i 3.
"""
function sum_sorted_asc(x::Vector{T}, y::Vector{T}) where T<:AbstractFloat
    products = [x[i] * y[i] for i in 1:length(x)]
    
    pos_products = filter(p -> p > 0, products)
    neg_products = filter(p -> p < 0, products)
    
    # Sortowanie "przeciwnie do (c)" 
    sort!(pos_products)           # Dodatnie: od najmniejszego
    sort!(neg_products, rev=true) # Ujemne: od największego
    
    # Sumowanie częściowe
    sum_pos = T(0.0)
    for p in pos_products
        sum_pos += p
    end
    
    sum_neg = T(0.0)
    for p in neg_products
        sum_neg += p
    end
    
    return sum_pos + sum_neg
end

"""
    run_dot_product_test()

Główna funkcja uruchamiająca eksperyment z zadania 5.
Definiuje wektory, uruchamia testy dla Float32 i Float64,
i drukuje wyniki oraz błędy względne.
"""
function run_dot_product_test()
    # Definicja wektorów w precyzji Float64 [cite: 32, 34]
    x_vec_64 = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
    y_vec_64 = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]
    
    # Prawidłowa wartość  (poprawiona notacja)
    correct_val = -1.00657107000000e-11
    
    println("--- ZADANIE 5: Błąd iloczynu skalarnego (Katastrofalne anulowanie) ---")
    println("Wartość dokładna: $(correct_val)")

    precisions = [Float32, Float64]
    
    for T in precisions
        println("\n--- Testy dla precyzji: $(T) ---")
        
        # Konwersja wektorów do badanej precyzji 
        x_vec_T = T.(x_vec_64)
        y_vec_T = T.(y_vec_64)
        
        # Obliczenia
        s_a = sum_forward(x_vec_T, y_vec_T)
        s_b = sum_backward(x_vec_T, y_vec_T)
        s_c = sum_sorted_desc(x_vec_T, y_vec_T)
        s_d = sum_sorted_asc(x_vec_T, y_vec_T)
        
        # Błędy względne
        err_a = abs(s_a - correct_val) / abs(correct_val)
        err_b = abs(s_b - correct_val) / abs(correct_val)
        err_c = abs(s_c - correct_val) / abs(correct_val)
        err_d = abs(s_d - correct_val) / abs(correct_val)
        
        # Prezentacja wyników
        println("| Metoda (wg PDF) | Wynik obliczeń           | Błąd względny          |")
        println("|-----------------|--------------------------|------------------------|")
        println("| (a) 'w przód'   | $(s_a) | $(err_a) |")
        println("| (b) 'w tył'     | $(s_b) | $(err_b) |")
        println("| (c) 'od najw.'  | $(s_c) | $(err_c) |")
        println("| (d) 'od najm.'  | $(s_d) | $(err_d) |")
    end
end

# Uruchomienie programu
run_dot_product_test()
