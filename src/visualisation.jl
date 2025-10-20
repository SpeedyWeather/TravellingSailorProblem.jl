using GeoMakie

# make commutative
function SpeedyWeather.globe(
    particle_tracker::SpeedyWeather.ParticleTracker,
    destinations::NTuple{N, <:Destination};
    kwargs...,
) where N 
    SpeedyWeather.globe(destinations, particle_tracker; kwargs...)
end

function SpeedyWeather.globe(
    destinations::NTuple{N, <:Destination},
    particle_tracker::Union{Nothing, SpeedyWeather.ParticleTracker}=nothing;
    names::Bool = false,
    background::Bool = true,
    coastlines::Bool = false,
    interactive::Bool = true,
    perspective = (30, 45),
    size=(800, 800),
) where N

    fig = Figure(size=size);

    if interactive
        transf = GeoMakie.Geodesy.ECEFfromLLA(GeoMakie.Geodesy.WGS84())
        ax = LScene(fig[1,1], show_axis=false);
    else
        ax = GeoAxis(fig[1, 1],
            dest = "+proj=ortho +lon_0=$(perspective[1]) +lat_0=$(perspective[2])")
    end

    # background image
    if background
        bg = meshimage!(ax, -180..180, -90..90, rotr90(GeoMakie.earth());
            npoints = 100, z_level = -100_000)
        interactive && (bg.transformation.transform_func[] = transf)
    end

    # coastlines
    if coastlines
        cl = lines!(GeoMakie.coastlines(50); color=:grey, linewidth=1)
        interactive && (cl.transformation.transform_func[] = transf)
    end

    # visualise tracks
    if !isnothing(particle_tracker)
        ds = NCDataset(joinpath(particle_tracker.path, particle_tracker.filename))
        plon = ds["lon"][:, :]
        plat = ds["lat"][:, :]
        particles = ds["particle"][:]

        for i in eachindex(particles)
            pl = lines!(ax, plon[i, :], plat[i, :], linewidth=2)
            interactive && (pl.transformation.transform_func[] = transf)
        end
    end

    # visualise destinations
    lons = [d.lonlat[1] for d in destinations]
    lats = [d.lonlat[2] for d in destinations]

    colors = [d.reached ? 0 : 1 for d in destinations]
    c1 = scatter!(ax, lons, lats, zero(lons); marker=:hexagon, color=:black, markersize=22)
    c2 = scatter!(ax, lons, lats, zero(lons); marker=:hexagon, color=colors, markersize=20)
    interactive && (c1.transformation.transform_func[] = transf)
    interactive && (c2.transformation.transform_func[] = transf)

    # add names
    if names
        for d in destinations
            t = text!(ax, d.lonlat[1], d.lonlat[2], text=string(d.name), align=(:right, :baseline))
            interactive && (t.transformation.transform_func[] = transf)
        end
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