using GeoMakie, FileIO
import Proj, GeometryOps, GeoInterface, GeoFormatTypes

const ASSETS_PATH = joinpath(dirname(@__DIR__), "assets")
mkpath(ASSETS_PATH)  # create assets directory if it doesn't exist

if !isfile(joinpath(ASSETS_PATH, "bluemarble.png"))
    # @info "Downloading bluemarble background image."
    download("https://eoimages.gsfc.nasa.gov/images/imagerecords/76000/76487/world.200406.3x5400x2700.png", joinpath(ASSETS_PATH, "bluemarble.png"))
end

function bad_spherical_cap(point, radius; npoints = 100)
    points = [radius .* reverse(sincos(t)) for t in LinRange(0, 2pi, npoints)]
    poly = GeoInterface.Polygon([GeoInterface.LinearRing(points)])
    return GeometryOps.reproject(
        poly;
        source_crs = GeoFormatTypes.ProjString("+proj=ortho +lon_0=$(GeoInterface.x(point)) +lat_0=$(GeoInterface.y(point))"),
        target_crs = GeoFormatTypes.EPSG(4326)
    )
end

export globe

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
    background::Bool = true,
    coastlines::Bool = true,
    interactive::Bool = true,
    shadows::Bool = true,
    track_labels::Bool = true,
    track_numbers::Bool = true,
    legend::Bool = true,
    altitude_tracks = 200_000,
    altitude_destinations = 200_000,
    perspective = (0, 0),
    altitude = 2e7,
    size = (800, 800),
) where N

    perspective = perspective isa Destination ? perspective.lonlat : perspective

    Makie.set_theme!(Attributes(; palette = (; color = Makie.to_colormap(:tab20), patchcolor = Makie.to_colormap(:tab20))))

    fig = Figure(size=size);

    if interactive
        ax = GlobeAxis(fig[1, 1]; show_axis = false)

        # starting perspective
        ecef = GeoMakie.Geodesy.ECEFfromLLA(GeoMakie.wgs84)(
            GeoMakie.Geodesy.LLA(; 
            lon = perspective[1], 
            lat = perspective[2], 
            alt = altitude,
        ))

        # Now, we update the camera
        cc = cameracontrols(ax.scene)
        cc.eyeposition[] = ecef
        cc.lookat[] = Vec3d(0,0,0)
        cc.upvector[] = Vec3d(0,0,1)
        Makie.update_cam!(ax.scene, cc)

    else
        ax = GeoAxis(fig[1, 1],
            dest = "+proj=ortho +lon_0=$(perspective[1]) +lat_0=$(perspective[2])")
    end

    # background image
    if background
        earth = isfile(joinpath(ASSETS_PATH, "bluemarble.png")) ? load(joinpath(ASSETS_PATH, "bluemarble.png")) : GeoMakie.earth()
        grey_earth = rotr90(Gray.(earth)) .* 0.5 .+ 0.2
        meshimage!(ax, -180..180, -90..90, grey_earth; npoints = 100)
    end

    # coastlines
    if coastlines
        lines!(ax, GeoMakie.coastlines(50); color=:white, linewidth=0.2)
    end

    # visualise tracks
    if !isnothing(particle_tracker)
        ds = NCDataset(joinpath(particle_tracker.path, particle_tracker.filename))
        plon = ds["lon"][:, :]
        plat = ds["lat"][:, :]
        pz = altitude_tracks .+ zero(plon)
        particles = ds["particle"][:]

        for i in eachindex(particles)
            lines!(ax, plon[i, :], plat[i, :], pz[i, :] .* 0.8, color=Cycled(i), linewidth=2)
            shadows && lines!(ax, plon[i, :], plat[i, :], pz[i, :] .* 0.1, color=:black, alpha=0.5, linewidth=2)
            if track_labels
                scatter!(ax, plon[i, end], plat[i, end], pz[i, end]; color=:black, marker=:circle, markersize=22)
                shadows && scatter!(ax, plon[i, end], plat[i, end], pz[i, end] .* 0.3; color=:black, marker=:circle, alpha=0.5, markersize=22)
                scatter!(ax, plon[i, end], plat[i, end], pz[i, end]; color=:white, marker=:circle, markersize=20)
                track_numbers && scatter!(ax, plon[i, end], plat[i, end], pz[i, end]; color=:black, marker=Char(48+mod(i, 10)), markersize=10)
            end
        end
    end

    # visualise destinations
    lons = [d.lonlat[1] for d in destinations]
    lats = [d.lonlat[2] for d in destinations]
    radii = [d.radius for d in destinations]
    z = fill(altitude_destinations, length(lons))

    colors = [d.reached ? 0 : 1 for d in destinations]
    colors2 = [d.reached ? 1 : 0 for d in destinations]
    markers = [only(string(d.name)[1]) for d in destinations]
    scatter!(ax, lons, lats, z; marker=:hexagon, color=:black, markersize=22)
    scatter!(ax, lons, lats, z; marker=:hexagon, color=colors,
        colorrange=(0, 1), markersize=20)
    scatter!(ax, lons, lats, z; marker=markers, color=colors2, colorrange=(0, 1), markersize=10)

    if shadows
        circles = [bad_spherical_cap(Point2f(lon, lat), radius) for (lon, lat, radius) in zip(lons, lats, radii)]
        poly!(ax, circles, color=colors, colorrange=(0,1), alpha=0.3, zlevel=10_000)
    end

    # dummy scatter for legend
    scatter!(ax, 0, 0, -1e6; marker='1', color=:black, markersize=14, label="particle start")
    scatter!(ax, 0, 0, -1e6; marker=:hexagon, color=0, colorrange=(0, 1), markersize=16, label="reached")
    scatter!(ax, 0, 0, -1e6; marker=:hexagon, color=1, colorrange=(0, 1), markersize=16, label="missed")

    legend && axislegend(ax, position=:lb)

    fig
end 