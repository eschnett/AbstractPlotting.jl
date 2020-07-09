@block SimonDanisch ["2d"] begin

    @cell "Test heatmap + image overlap" [image, heatmap, transparency] begin
        heatmap(RNG.rand(32, 32))
        image!(map(x->RGBAf0(x,0.5, 0.5, 0.8), RNG.rand(32,32)))
    end

    @cell "poly and colormap" [poly, colormap, colorrang] begin
        # example by @Paulms from JuliaPlots/Makie.jl#310
        points = Point2f0[[0.0, 0.0], [0.1, 0.0], [0.1, 0.1], [0.0, 0.1]]
        colors = [0.0 ,0.0, 0.5, 0.0]
        scene = poly(points, color = colors, colorrange = (0.0,1.0))
        points = Point2f0[[0.1, 0.1], [0.2, 0.1], [0.2, 0.2], [0.1, 0.2]]
        colors = [0.5,0.5,1.0,0.3]
        poly!(scene, points, color = colors, colorrange = (0.0,1.0))
        scene
    end
    @cell "quiver" [quiver, arrows, vectorfield, gradient] begin
        x = range(-2, stop = 2, length = 21)
        arrows(x, x, RNG.rand(21, 21), RNG.rand(21, 21), arrowsize = 0.05)
    end
    @cell "Arrows on hemisphere" [arrows, quiver, mesh] begin
        using GeometryBasics
        s = Sphere(Point3f0(0), 0.9f0)
        scene = mesh(s, transparency=true, alpha=0.05)
        pos = decompose(Point3f0, s)
        dirs = decompose_normals(s)
        arrows!(scene, pos, dirs, arrowcolor=:red, arrowsize=0.1, linecolor=:red)
    end
    @cell "image" [image] begin
        vbox(
            image(AbstractPlotting.logo(), scale_plot = false),
            image(RNG.rand(100, 500), scale_plot = false),
        )
    end
    @cell "FEM polygon 2D" [fem, poly] begin
        coordinates = [
            0.0 0.0;
            0.5 0.0;
            1.0 0.0;
            0.0 0.5;
            0.5 0.5;
            1.0 0.5;
            0.0 1.0;
            0.5 1.0;
            1.0 1.0;
        ]
        connectivity = [
            1 2 5;
            1 4 5;
            2 3 6;
            2 5 6;
            4 5 8;
            4 7 8;
            5 6 9;
            5 8 9;
        ]
        color = [0.0, 0.0, 0.0, 0.0, -0.375, 0.0, 0.0, 0.0, 0.0]
        poly(coordinates, connectivity, color = color, strokecolor = (:black, 0.6), strokewidth = 4)
    end
    @cell "FEM mesh 2D" [fem, mesh] begin
        coordinates = [
            0.0 0.0;
            0.5 0.0;
            1.0 0.0;
            0.0 0.5;
            0.5 0.5;
            1.0 0.5;
            0.0 1.0;
            0.5 1.0;
            1.0 1.0;
        ]
        connectivity = [
            1 2 5;
            1 4 5;
            2 3 6;
            2 5 6;
            4 5 8;
            4 7 8;
            5 6 9;
            5 8 9;
        ]
        color = [0.0, 0.0, 0.0, 0.0, -0.375, 0.0, 0.0, 0.0, 0.0]
        scene = mesh(coordinates, connectivity, color = color, shading = false)
        wireframe!(scene[end][1], color = (:black, 0.6), linewidth = 3)
    end
    @cell "colored triangle" [mesh, polygon] begin
        mesh(
            [(0.0, 0.0), (0.5, 1.0), (1.0, 0.0)], color = [:red, :green, :blue],
            shading = false
        )
    end
    @cell "colored triangle" [polygon] begin
        poly(
            [(0.0, 0.0), (0.5, 1.0), (1.0, 0.0)],
            color = [:red, :green, :blue],
            strokecolor = :black, strokewidth = 2
        )
    end
    @cell "Subscenes" [image, scatter, subscene] begin
        img = RNG.rand(RGBAf0, 100, 100)
        scene = image(img, show_axis = false)
        subscene = Scene(scene, IRect(100, 100, 300, 300))
        scatter!(subscene, RNG.rand(100) * 200, RNG.rand(100) * 200, markersize = 4)
        scene
    end

    @cell "scale_plot" [scale] begin
        t = range(0, stop=1, length=500) # time steps
        θ = (6π) .* t    # angles
        x =  # x coords of spiral
        y =  # y coords of spiral
        p1 = lines(t .* cos.(θ), t .* sin.(θ);
            color = t, colormap = :algae, linewidth = 8,
            scale_plot = false)
    end

    @cell "Polygons" [poly, polygon, linesegments] begin
        using GeometryBasics
        scene = Scene(resolution = (500, 500))
        points = decompose(Point2f0, Circle(Point2f0(50), 50f0))
        pol = poly!(scene, points, color = :gray, strokewidth = 10, strokecolor = :red)
        # Optimized forms
        poly!(scene, [Circle(Point2f0(50+300), 50f0)], color = :gray, strokewidth = 10, strokecolor = :red)
        poly!(scene, [Circle(Point2f0(50+i, 50+i), 10f0) for i = 1:100:400], color = :red)
        poly!(scene, [FRect2D(50+i, 50+i, 20, 20) for i = 1:100:400], strokewidth = 2, strokecolor = :green)
        linesegments!(scene,
            [Point2f0(50 + i, 50 + i) => Point2f0(i + 70, i + 70) for i = 1:100:400], linewidth = 8, color = :purple
        )
    end

    @cell "Contour Function" [contour] begin
        r = range(-10, stop = 10, length = 512)
        z = ((x, y)-> sin(x) + cos(y)).(r, r')
        contour(r, r, z, levels = 5, colormap = :viridis, linewidth = 3)
    end
    @cell "Hbox" [lines, scatter, hbox] begin
        t = range(-122277.9, stop=-14798.0, length=29542)
        x = -42 .- randn(length(t))
        sc1 = scatter(t, x, color=:black, markersize=sqrt(length(t)/20))
        sc2 = lines(t[1:end-1], diff(x), color = :blue)
        hbox(sc2, sc1)
    end
    @cell "Customize Axes" [lines, axis] begin
        x = LinRange(0,3pi,200); y = sin.(x)
        lin = lines(x, y, padding = (0.0, 0.0), axis = (
            names = (axisnames = ("", ""),),
            grid = (linewidth = (0, 0),),
        ))
    end
    @cell "contour" [contour] begin
        y = range(-0.997669, stop = 0.997669, length = 23)
        contour(range(-0.99, stop = 0.99, length = 23), y, RNG.rand(23, 23), levels = 10)
    end

    @cell "Text Annotation" [text, align, annotation] begin
        text(
            ". This is an annotation!",
            position = (300, 200),
            align = (:center,  :center),
            textsize = 60,
            font = "Blackchancery"
        )
    end

    @cell "Text rotation" [text, rotation] begin
        scene = Scene()
        pos = (500, 500)
        posis = Point2f0[]
        for r in range(0, stop = 2pi, length = 20)
            global pos, posis
            p = pos .+ (sin(r)*100.0, cos(r) * 100)
            push!(posis, p)
            t = text!(
                scene, "test",
                position = p,
                textsize = 50,
                rotation = 1.5pi - r,
                align = (:center, :center)
            )
        end
        scatter!(scene, posis, markersize = 10)
    end
    @cell "Standard deviation band" [band, lines, statistics] begin
        # Sample 100 Brownian motion path and plot the mean trajectory together
        # with a ±1σ band (visualizing uncertainty as marginal standard deviation).
        using Statistics
        n, m = 100, 101
        t = range(0, 1, length=m)
        X = cumsum(randn(n, m), dims = 2)
        X = X .- X[:, 1]
        μ = vec(mean(X, dims=1)) # mean
        lines(t, μ)              # plot mean line
        σ = vec(std(X, dims=1))  # stddev
        band!(t, μ + σ, μ - σ)   # plot stddev band
    end

    @cell "Streamplot animation" ["streamplot", "animation"] begin
        v(x::Point2{T}, t) where T = Point2{T}(one(T) * x[2] * t, 4 * x[1])
        sf = Node(Base.Fix2(v, 0e0))
        title_str = Node("t = 0.00")
        sp = streamplot(sf, -2..2, -2..2;
                        linewidth = 2, padding = (0, 0),
                        arrow_size = 0.09, colormap =:magma)
        sc = title(sp, title_str)
        record(sc, @replace_with_a_path(mp4), LinRange(0, 20, 5)) do i
            sf[] = Base.Fix2(v, i)
            title_str[] = "t = $(round(i; sigdigits = 2))"
        end
    end
end

@block AnshulSinghvi ["colors"] begin

    @cell "Line changing colour" [colors, lines, animation] begin
        scene = lines(RNG.rand(10); linewidth=10)

        record(scene, @replace_with_a_path(mp4), 1:255; framerate = 60) do i
               scene.plots[2][:color] = RGBf0(i/255, (255 - i)/255, 0) # animate scene
        end
    end


    @cell "streamplot" [arrows, lines, streamplot] begin
        struct FitzhughNagumo{T}
            ϵ::T
            s::T
            γ::T
            β::T
        end

        P = FitzhughNagumo(0.1, 0.0, 1.5, 0.8)
        f(x, P::FitzhughNagumo) = Point2f0(
            (x[1]-x[2]-x[1]^3+P.s)/P.ϵ,
            P.γ*x[1]-x[2] + P.β
        )
        f(x) = f(x, P)
        streamplot(f, -1.5..1.5, -1.5..1.5, colormap = :magma)
    end
end

@block AnshulSinghvi ["Transformations"] begin
    @cell "Transforming lines" [transformation, lines] begin
        N = 7 # number of colours in default palette
        sc = Scene()
        st = Stepper(sc, @replace_with_a_path)

        xs = 0:9        # data
        ys = zeros(10)

        for i in 1:N    # plot lines
            lines!(sc,
                xs, ys;
                color = AbstractPlotting.default_palettes.color[][i],
                limits = FRect((0, 0), (10, 10)),
                linewidth = 5
            ) # plot lines with colors
        end

        center!(sc)

        step!(st)

        for (i, rot) in enumerate(LinRange(0, π/2, N))
            rotate!(sc.plots[i+1], rot)
            arc!(sc,
                Point2f0(0),
                (8 - i),
                pi/2,
                (pi/2-rot);
                color = sc.plots[i+1].color,
                linewidth = 5,
                linestyle = :dash
            )
        end

        step!(st)
    end
end

@block JuliusKrumbiegel ["2d"] begin
    @cell "Errorbars x y low high" [errorbars] begin
        x = 1:10
        y = sin.(x)
        scene = scatter(x, y)
        errorbars!(scene, x, y, RNG.rand(10) .+ 0.5, RNG.rand(10) .+ 0.5)
        errorbars!(scene, x, y, RNG.rand(10) .* 0.3 .+ 0.1, RNG.rand(10) .* 0.3 .+ 0.1,
            color = :red, direction = :x)
        scene
    end

    @cell "Errorbars xy low high" [errorbars] begin
        x = 1:10
        y = sin.(x)
        xy = Point2f0.(x, y)
        scene = scatter(xy)
        errorbars!(scene, xy, RNG.rand(10) .+ 0.5, RNG.rand(10) .+ 0.5)
        errorbars!(scene, xy, RNG.rand(10) .* 0.3 .+ 0.1, RNG.rand(10) .* 0.3 .+ 0.1,
            color = :red, direction = :x)
        scene
    end

    @cell "Errorbars xy error" [errorbars] begin
        x = 1:10
        y = sin.(x)
        xy = Point2f0.(x, y)
        scene = scatter(xy)
        errorbars!(scene, xy, RNG.rand(10) .+ 0.5)
        errorbars!(scene, xy, RNG.rand(10) .* 0.3 .+ 0.1,
            color = :red, direction = :x)
        scene
    end

    @cell "Simple pie chart" [pie] begin
        using AbstractPlotting.MakieLayout
        scene, layout = layoutscene(resolution = (800, 800))
        ax = layout[1, 1] = LAxis(scene, autolimitaspect = 1)

        pie!(ax, 1:5, color = 1:5)

        scene
    end

    @cell "Hollow pie chart" [pie] begin
        using AbstractPlotting.MakieLayout
        scene, layout = layoutscene(resolution = (800, 800))
        ax = layout[1, 1] = LAxis(scene, autolimitaspect = 1)

        pie!(ax, 1:5, color = 1:5, radius = 2, inner_radius = 1)

        scene
    end

    @cell "Open pie chart" [pie] begin
        using AbstractPlotting.MakieLayout
        scene, layout = layoutscene(resolution = (800, 800))
        ax = layout[1, 1] = LAxis(scene, autolimitaspect = 1)

        pie!(ax, 0.1:0.1:1.0, normalize = false)
        scene
    end
end
