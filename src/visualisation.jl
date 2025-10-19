using GeoMakie

function SpeedyWeather.globe(
    destinations::Destination...;
    names::Bool = false,
    background::Bool = true,
    coastlines::Bool = true,
    interactive::Bool = true,
    perspective = (30, 45),
    size=(800, 800),
)
    fig = Figure(size=size);

    if interactive
        transf = GeoMakie.Geodesy.ECEFfromLLA(GeoMakie.Geodesy.WGS84())
        ax = LScene(fig[1,1], show_axis=false);
    else
        ax = GeoAxis(fig[1, 1],
            dest = "+proj=ortho +lon_0=$(perspective[1]) +lat_0=$(perspective[2])")
    end

    lons = [d.lonlat[1] for d in destinations]
    lats = [d.lonlat[2] for d in destinations]

    c = scatter!(ax, lons, lats, zero(lons); color=:black, markersize=10, marker=:star5)
    interactive && (c.transformation.transform_func[] = transf)

    if names
        for d in destinations
            t = text!(ax, d.lonlat[1], d.lonlat[2], text=string(d.name), align=(:right, :baseline))
            interactive && (t.transformation.transform_func[] = transf)
        end
    end

    # background image
    if background
        bg = meshimage!(ax, -180..180, -90..90, rotr90(GeoMakie.earth());
            npoints = 100, z_level = -10_000)
        interactive && (bg.transformation.transform_func[] = transf)
    end

    # coastlines
    if coastlines
        cl = lines!(GeoMakie.coastlines(50); color=:grey, linewidth=0.5)
        interactive && (cl.transformation.transform_func[] = transf)
    end

    # Makie stuff
    if interactive
        cc = cameracontrols(ax.scene)
        cc.settings.mouse_translationspeed[] = 0.0
        cc.settings.zoom_shift_lookat[] = false
        Makie.update_cam!(ax.scene, cc)
    else
        hidedecorations!(ax)
    end

    fig
end 