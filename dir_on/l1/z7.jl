#=
Autor: Maksymilian Kulakowski 
Przedmiot: Obliczenia naukowe
Zadanie: 7, Lista 1

Program oblicza przybliżoną wartość pochodnej funkcji
f(x) = sin(x) + cos(3x) w punkcie x0 = 1
używając wzoru różnicowego (f(x0+h) - f(x0))/h
dla kolejnych kroków h = 2^(-n), gdzie n = 0, 1, ..., 54.

Program oblicza błąd bezwzględny przybliżenia i bada zachowanie
wartości 1 + h.
=#

using Printf # Do formatowania wydruku

"""
    f(x::Float64)

Oblicza wartość funkcji f(x) = sin(x) + cos(3x).

# Argumenty
- `x`: Punkt (Float64), w którym obliczana jest funkcja.

# Zwraca
- Wartość funkcji (Float64).
"""
function f(x::Float64)
    return sin(x) + cos(3 * x)
end

"""
    f_prime_exact(x::Float64)

Oblicza dokładną wartość pochodnej f'(x) = cos(x) - 3sin(3x).

# Argumenty
- `x`: Punkt (Float64), w którym obliczana jest pochodna.

# Zwraca
- Dokładną wartość pochodnej (Float64).
"""
function f_prime_exact(x::Float64)
    return cos(x) - 3 * sin(3 * x)
end

"""
    approx_derivative(x0::Float64, h::Float64)

Oblicza przybliżoną wartość pochodnej za pomocą wzoru
(f(x0 + h) - f(x0)) / h.

# Argumenty
- `x0`: Punkt obliczenia pochodnej (Float64).
- `h`: Krok różnicowy (Float64).

# Zwraca
- Przybliżoną wartość pochodnej (Float64).
"""
function approx_derivative(x0::Float64, h::Float64)
    return (f(x0 + h) - f(x0)) / h
end

# --- Główna część programu ---
function main()
    # Punkt, w którym liczymy pochodną
    x0::Float64 = 1.0
    
    # Obliczenie "dokładnej" wartości jako referencji
    exact_val::Float64 = f_prime_exact(x0)
    
    println("Badanie błędu obliczania pochodnej f(x) = sin(x) + cos(3x) w x0 = 1.0")
    println("Arytmetyka: Float64")
    println("Wartość dokładna f'(1) = cos(1) - 3sin(3) = $exact_val")
    println("-"^80)
    @printf("%-5s %-18s %-25s %-25s %-15s\n", "n", "h = 2^(-n)", "Przybliżenie f'~", "Błąd |f' - f'~|", "1.0 + h == 1.0?")
    println("-"^80)
    
    # Pętla po n od 0 do 54
    for n in 0:54
        h::Float64 = 2.0^(-n)
        
        # Obliczenie przybliżonej wartości pochodnej
        approx_val::Float64 = approx_derivative(x0, h)
        
        # Obliczenie błędu bezwzględnego
        abs_error::Float64 = abs(exact_val - approx_val)
        
        # Obserwacja zachowania 1 + h
        one_plus_h_equals_one = (1.0 + h == 1.0)
        
        @printf("%-5d %-18.5e %-25.15f %-25.15e %-15s\n", n, h, approx_val, abs_error, one_plus_h_equals_one)
    end
    
    println("-"^80)
    println("Epsilon maszynowy dla Float64: $(eps(Float64))")
    println("h dla n=52: $(2.0^-52) (równe eps(1.0))")
    println("h dla n=53: $(2.0^-53) (równe eps(1.0)/2)")
end

# Wywołanie głównej funkcji
main()
