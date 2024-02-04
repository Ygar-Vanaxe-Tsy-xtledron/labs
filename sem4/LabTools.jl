module LabTools

    import Base.+, Base.-, Base.*, Base./, Base.^ # Имтортируем арифмитические операции, чтобы их расширить на экспериментальные значения
    using DataFrames # Датафреймы, которые мы будем преобразоывыть в латех
    export exval, ϵ, +, -, *, /, ^, tabulate

    struct exval # Экспериментальное значение
        x::Float64 # Измеренное значение
        σ::Float64 # Абсолютная погрешность
    end

    function ϵ(a::exval) # Относитальная погрешность величины
        return a.σ / a.x 
    end

    #= Далее мы определяем арифмитические операции/функции для exval 
    Пусть c = f(a,b)
    Тогда dc = f'a * da + f'b * db
    Соответсттвенно
    σ_c = √(f'a * σ_a)^2 +(f'b * σ_b)^2) =#

    function +(a::exval, b::exval)
        return exval(a.x + b.x, sqrt(a.σ^2 + b.σ^2))
    end

    function -(a::exval, b::exval)
        return exval(a.x - b.x, sqrt(a.σ^2 + b.σ^2))
    end

    function *(a::exval, b::exval)
        return exval(a.x * b.x, sqrt((a.x*b.σ)^2 + (b.x*a.σ)^2))
    end

    function *(a::exval, b::Float64)
        return exval(a.x * b, a.σ * b)
    end 

    function /(a::exval, b::exval)
        return exval(a.x / b.x, sqrt((a.σ/b.x)^2 + (b.σ/b.x^2)^2))
    end

    function /(a::exval, b::Float64)
        return exval(a.x / b, a.σ / b)
    end

    function ^(a::exval, b::Float64)
        return exval(a.x ^ b, b * (a.x)^(b-1) * a.σ)
    end
    
    # Техаем таблицу по csv
    function tabulate(df::DataFrame)
        cs = "{"
        for _ in 1:ncol(df)
            cs *= "|c"
        end
        cs *= "|}"

        println("\\begin{tabular}{$cs}")
        println("\\hline")
        line = ""
        for i ∈ names(df)
            line *= string(i) * " & "
        end
        line = chopsuffix(line, "& ")
        line *= "\\\\"
        println(line)
        print("\\hline")

        for i ∈ 1:nrow(df)
            line = ""
            for j ∈ df[i, :]
                line *= string(j) * " & " 
            end
            line = chopsuffix(line, "& ")
            line *= "\\\\"
            println(line)
            println("\\hline")
        end
            
        println("\\end{tabular}")
    end
end